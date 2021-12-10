defmodule ExOpcua.Protocol do
  @moduledoc """
  Documentation for `ExOpcua.Protocol`.
  """

  @doc """
  This Module provides decode and encode functions for OPC UA comms
  Protocol docs: https://reference.opcfoundation.org/v104/Core/docs/Part6/6.7.1/
  ## Examples

      iex> ExOpcua.decode("ACK")
      :ack

  """
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString
  alias ExOpcua.DataTypes.NodeId
  alias ExOpcua.Protocol.Headers
  alias ExOpcua.Services

  @default_version 0
  @default_cert opc_null_value()
  @frame_head_size 8
  @message_types [
    open_secure_channel: "OPN",
    close_secure_channel: "CLO",
    message: "MSG"
  ]
  @is_final [
    intermediate: "C",
    final: "F",
    final_aborted: "A"
  ]

  @spec recieve_message(ExOpcua.Session.State.t()) ::
          {:ok, %{payload: any, header: struct()}} | atom()
  def recieve_message(session) do
    session
    |> recieve_frame()
    |> decode_message()
  end

  def recieve_message(session, :debug) do
    {head, mess} =
      message =
      session
      |> recieve_frame()

    IO.inspect(Base.encode16(mess), limit: :infinity)

    decode_message(message)
  end

  @spec recieve_frame(ExOpcua.Session.State.t(), binary()) :: {struct(), binary()}
  defp recieve_frame(session, message_acc \\ <<>>)

  defp recieve_frame(%{socket: socket, req_id: request_id} = session, message_acc) do
    with {:ok, <<_::bytes-size(4), msg_size::int(32)>> = frame_info} <-
           :gen_tcp.recv(socket, @frame_head_size, 10_000),
         {:ok, frame} <- :gen_tcp.recv(socket, msg_size - @frame_head_size, 2_000),
         full_frame <- frame_info <> frame,
         {%{} = header, full_frame} <- Headers.take(full_frame) do
      case header do
        # hello header is never intermediate or encrypted
        %Headers.HelloHeader{} ->
          {header, full_frame}

        # OpenSecureChannel is never intermediate and always Asymetrically Encrypted (if not none)
        %Headers.OpenSecureChannelHeader{} ->
          <<_seq_num::little-unsigned-integer-size(32),
            ^request_id::little-unsigned-integer-size(32),
            full_frame::binary>> =
            ExOpcua.SecurityProfile.decrypt_data(full_frame, session.security_profile)

          {header, full_frame}

        # All other messages can be partial or final, and use Symetric Encryption is not :none
        %{chunk_type: :intermediate} ->
          full_frame =
            ExOpcua.SecurityProfile.sym_decrypt_data(full_frame, session.security_profile)

          <<_seq_num::little-unsigned-integer-size(32),
            ^request_id::little-unsigned-integer-size(32),
            full_frame::binary>> = binary_part(full_frame, 0, byte_size(full_frame) - 33)

          recieve_frame(session, message_acc <> full_frame)

        %{chunk_type: :final} = header ->
          full_frame =
            ExOpcua.SecurityProfile.sym_decrypt_data(full_frame, session.security_profile)

          <<_seq_num::little-unsigned-integer-size(32),
            ^request_id::little-unsigned-integer-size(32), full_frame::binary>> = full_frame

          {header, message_acc <> full_frame}

        other_output ->
          other_output
      end
    end
  end

  def encode_hello_message(url) do
    # messages without URL are 32 bytes
    payload = <<
      @default_version::integer-size(32),
      # rec_buff_size
      147_456::int(32),
      # send_buff_size
      147_456::int(32),
      # max_msg_size
      4_194_240::int(32),
      # max_chunk_count
      65535::int(32),
      serialize_string(url)
    >>

    msg_size = 8 + byte_size(payload)

    <<"HEL"::binary, @is_final[:final]::binary, msg_size::int(32)>> <> payload
  end

  # @spec encode_message(atom(), [any]) :: binary() | :error
  # def encode_message(
  #       :browse_request,
  #       %{
  #         sec_channel_id: sec_channel_id,
  #         token_id: token_id,
  #         auth_token: auth_token,
  #         seq_number: seq_number
  #       }
  #     ) do
  #   payload = <<
  #     sec_channel_id::int(32),
  #     token_id::int(32),
  #     seq_number::int(32),
  #     seq_number::int(32),
  #     0x01,
  #     0x00,
  #     527::int(16),
  #     # request_header
  #     NodeId.serialize(auth_token)::binary,
  #     # timestamp
  #     BuiltInDataTypes.Timestamp.from_datetime(DateTime.utc_now())::int(64),
  #     # request handle and diagnostics
  #     0::int(64),
  #     # audit entry id
  #     opc_null_value(),
  #     # timeout hint
  #     0::int(32),
  #     # additional header
  #     0x00,
  #     0x00,
  #     0x00,
  #     # view description
  #     0::size(14)-unit(8),
  #     # requested max ref per node
  #     1000::int(32),
  #     # nodes to browse array
  #     # size
  #     1::int(32),
  #     # browse description
  #     0x00,
  #     0x2D,
  #     # browse direction (forward)
  #     0::int(32),
  #     # reference node type (not specified)
  #     0xFF::size(2)-unit(8),
  #     # include subtypes
  #     0x01,
  #     # node class
  #     0::int(32),
  #     63::int(32)
  #   >>

  #   msg_size = 8 + byte_size(payload)

  #   <<
  #     @message_types[:message]::binary,
  #     @is_final[:final]::binary,
  #     msg_size::int(32)
  #   >> <> payload
  # end

  # def encode_message(_, _) do
  #   :not_implemented
  # end

  def build_asymetric_packet(
        payload,
        %{
          req_id: req_id,
          seq_number: seq_number,
          security_profile: sec_profile
        } = session_info
      ) do
    seq_number = seq_number + 1
    req_id = req_id + 1

    # prepend sequence headers
    payload = <<seq_number::int(32), req_id::int(32)>> <> payload

    security_header = ExOpcua.SecurityProfile.asymetric_security_header(sec_profile)

    # payload + sequence header + signature (sha256)
    payload_bytes = byte_size(payload) + 256

    # padding needed to fit perfectly into encryption chunks (214 bytes = 256bytes encrypted)
    padding_size = 214 - rem(payload_bytes + 1, 214)

    padding = to_string(:string.chars(padding_size, padding_size + 1))

    msg_size =
      floor(
        (payload_bytes + byte_size(padding)) / 214 * 256 + byte_size(security_header) +
          @frame_head_size + 4
      )

    msg_header = message_header(msg_size, :final, :open_secure_channel)

    signature =
      (msg_header <> security_header <> payload <> padding)
      |> ExOpcua.SecurityProfile.sign(sec_profile)

    encrypted_payload =
      (payload <> padding <> signature)
      |> ExOpcua.SecurityProfile.encrypt_data(sec_profile)

    {%{session_info | req_id: req_id, seq_number: seq_number},
     msg_header <> security_header <> encrypted_payload}
  end

  def build_symetric_packet(
        payload,
        %{
          req_id: req_id,
          seq_number: seq_number,
          sec_channel_id: sec_channel_id,
          token_id: token_id,
          security_profile: sec_profile
        } = session_info
      ) do
    seq_number = seq_number + 1
    req_id = req_id + 1

    # prepend sequence headers
    payload = <<seq_number::int(32), req_id::int(32)>> <> payload

    security_header = <<token_id::int(32)>>

    # payload + sequence header + signature (sha256)
    payload_bytes = byte_size(payload) + 256

    # padding needed to fit perfectly into encryption chunks 16 byte chunks
    padding_size = 16 - rem(payload_bytes + 1, 16)

    payload = payload <> to_string(:string.chars(padding_size, padding_size + 1))

    msg_size = byte_size(security_header) + byte_size(payload) + 32 + @frame_head_size + 4

    msg_header = message_header(msg_size, :final, :message, sec_channel_id)

    signature =
      (msg_header <> security_header <> payload)
      |> ExOpcua.SecurityProfile.sign(sec_profile, :sym)

    encrypted_payload =
      (payload <> signature)
      |> ExOpcua.SecurityProfile.sym_encrypt_data(sec_profile)

    {%{session_info | req_id: req_id, seq_number: seq_number},
     msg_header <> security_header <> encrypted_payload}
  end

  def message_header(msg_size, is_final, message_type, sec_channel_id \\ 0) do
    <<
      @message_types[message_type]::binary,
      @is_final[is_final]::binary,
      msg_size::int(32),
      # channel_id
      sec_channel_id::int(32)
    >>
  end

  @spec decode_message({struct(), binary() | <<>>} | {:error, atom()}) ::
          {:ok, %{payload: any, header: struct()}} | {:error, atom()}
  def decode_message({header, <<>>}) do
    {:ok, %{header: header, payload: nil}}
  end

  def decode_message({header, bin_message}) do
    case Services.decode(bin_message) do
      {:ok, decoded_message} ->
        {:ok, %{header: header, payload: decoded_message}}

      {:error, reason} ->
        {reason, header, bin_message}

      _ ->
        {:error, :undefined_error}
    end
  end

  def decode_message(other) do
    {:error, other}
  end
end
