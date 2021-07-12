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
  alias ExOpcua.DataTypes.BuiltInDataTypes
  alias ExOpcua.DataTypes.NodeId
  alias ExOpcua.Protocol.Headers
  alias ExOpcua.Services

  @default_version 0
  @frame_head_size 8
  @message_types [
    hello: "HEL",
    open_secure_channel: "OPN",
    close_secure_channel: "CLO",
    message: "MSG"
  ]
  @is_final [
    intermediate: "C",
    final: "F",
    final_aborted: "A"
  ]

  @spec recieve_message(pid(), integer() | nil) ::
          {:ok, %{payload: any, header: struct()}} | atom()
  def recieve_message(socket, request_id \\ nil) do
    socket
    |> recieve_frame(request_id)
    |> decode_message()
  end

  @spec recieve_frame(pid(), integer() | nil, binary()) :: {struct(), binary()}
  defp recieve_frame(socket, request_id, message_acc \\ <<>>)

  defp recieve_frame(socket, request_id, message_acc) do
    with {:ok, <<_::bytes-size(4), msg_size::int(32)>> = frame_info} <-
           :gen_tcp.recv(socket, @frame_head_size, 10_000),
         {:ok, frame} <- :gen_tcp.recv(socket, msg_size - @frame_head_size, 2_000),
         full_frame <- frame_info <> frame do
      case Headers.decode_message_header(full_frame) do
        {%{req_id: ^request_id, chunk_type: :intermediate}, rest} ->
          recieve_frame(socket, request_id, message_acc <> rest)

        {%{req_id: ^request_id, chunk_type: :final} = header, rest} ->
          {header, message_acc <> rest}

        {%{chunk_type: :final} = header, rest} when is_nil(request_id) ->
          {header, rest}

        {:error, reason} ->
          reason
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

    <<@message_types[:hello]::binary, @is_final[:final]::binary, msg_size::int(32)>> <> payload
  end

  @spec encode_message(atom(), [any]) :: binary() | :error
  def encode_message(
        :browse_request,
        %{
          sec_channel_id: sec_channel_id,
          token_id: token_id,
          auth_token: auth_token,
          seq_number: seq_number
        }
      ) do
    payload = <<
      sec_channel_id::int(32),
      token_id::int(32),
      seq_number::int(32),
      seq_number::int(32),
      0x01,
      0x00,
      527::int(16),
      # request_header
      NodeId.serialize(auth_token)::binary,
      # timestamp
      BuiltInDataTypes.Timestamp.from_datetime(DateTime.utc_now())::int(64),
      # request handle and diagnostics
      0::int(64),
      # audit entry id
      opc_null_value(),
      # timeout hint
      0::int(32),
      # additional header
      0x00,
      0x00,
      0x00,
      # view description
      0::size(14)-unit(8),
      # requested max ref per node
      1000::int(32),
      # nodes to browse array
      # size
      1::int(32),
      # browse description
      0x00,
      0x2D,
      # browse direction (forward)
      0::int(32),
      # reference node type (not specified)
      0xFF::size(2)-unit(8),
      # include subtypes
      0x01,
      # node class
      0::int(32),
      63::int(32)
    >>

    msg_size = 8 + byte_size(payload)

    <<
      @message_types[:message]::binary,
      @is_final[:final]::binary,
      msg_size::int(32)
    >> <> payload
  end

  def encode_message(_, _) do
    :not_implemented
  end

  @spec append_message_header(binary(), atom(), atom()) :: binary()
  def append_message_header(payload, is_final \\ :final, message_type \\ :message)

  def append_message_header(payload, is_final, message_type) when is_binary(payload) do
    msg_size = @frame_head_size + byte_size(payload)

    <<
      @message_types[message_type]::binary,
      @is_final[is_final]::binary,
      msg_size::int(32)
    >> <> payload
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
