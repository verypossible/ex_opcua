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
  @default_cert opc_null_value()
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

        _ ->
          IO.inspect(request_id)
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

  @spec prepend_message_header(binary(), atom(), atom()) :: binary()
  def prepend_message_header(payload, is_final \\ :final, message_type \\ :message)

  def prepend_message_header(payload, is_final, message_type) when is_binary(payload) do
    msg_size = @frame_head_size + byte_size(payload)

    <<
      @message_types[message_type]::binary,
      @is_final[is_final]::binary,
      msg_size::int(32)
    >> <> payload
  end

  def prepend_message_header(payload, is_final, message_type) when is_binary(payload) do
    msg_size = @frame_head_size + byte_size(payload)

    <<
      @message_types[message_type]::binary,
      @is_final[is_final]::binary,
      msg_size::int(32)
    >> <> payload
  end

  def message_header(msg_size, is_final, message_type) do
    <<
      @message_types[message_type]::binary,
      @is_final[is_final]::binary,
      msg_size::int(32)
    >>
  end

  def wrap_message(
        payload,
        sec_policy,
        sender_private_key,
        sender_cert,
        recv_cert,
        seq_number,
        req_id
      ) do
    public_key =
      {:RSAPublicKey,
       17_613_116_168_005_741_559_508_673_914_679_911_427_152_126_075_015_720_884_747_549_322_715_312_277_771_805_797_246_804_608_358_133_295_364_536_958_573_402_497_218_733_093_038_152_155_852_039_778_223_294_464_307_773_355_937_317_681_021_460_052_294_644_640_439_570_330_219_521_047_950_558_571_564_401_119_785_350_013_899_486_602_675_276_714_539_219_702_336_473_312_348_831_077_166_603_806_121_401_989_067_184_409_819_454_792_343_971_931_110_008_813_654_511_443_863_286_262_701_178_634_311_212_942_466_996_381_029_141_413_688_861_764_289_232_673_917_446_735_068_497_836_269_568_722_076_137_198_235_518_366_416_701_366_986_863_857_930_617_424_754_275_421_711_493_983_881_680_996_508_284_001_271_531_990_280_778_716_858_554_997_441_653_730_398_211_999_069_310_113_576_894_613_285_930_509_050_283_983_314_963_045_475_957_932_709,
       65537}

    security_header = <<
      # channel_id
      0::int(32),
      serialize_string(sec_policy),
      # sender cert
      serialize_string(sender_cert),
      # reciever cert
      serialize_string(recv_cert)
    >>

    sequence_header = <<
      # sequence number
      seq_number::int(32),
      # request id
      req_id::int(32)
    >>

    # payload + sequence header + signature (sha256)
    payload_bytes = byte_size(payload) + byte_size(sequence_header) + 256

    # padding needed to fit perfectly into encryption chunks (214 bytes = 256bytes encrypted)
    padding_size = 214 - rem(payload_bytes + 1, 214)

    padding =
      List.duplicate(<<padding_size::int(8)>>, padding_size + 1)
      |> Enum.join()

    msg_size =
      floor(
        (payload_bytes + byte_size(padding)) / 214 * 256 + byte_size(security_header) +
          @frame_head_size
      )

    msg_header = message_header(msg_size, :final, :open_secure_channel)

    signature =
      (msg_header <> security_header <> sequence_header <> payload <> padding)
      |> :public_key.sign(:sha256, sender_private_key)

    encrypted_payload =
      (sequence_header <> payload <> padding <> signature)
      |> encrypt_data(public_key)

    msg_header <> security_header <> encrypted_payload
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

  def encrypt_data(data, public_key, acc \\ <<>>)

  def encrypt_data(<<>>, _public_key, acc) do
    acc
  end

  def encrypt_data(<<data_part::binary-size(214), rest::binary>>, public_key, acc) do
    encrypt_data(
      rest,
      public_key,
      acc <>
        :public_key.encrypt_public(data_part, public_key, [{:rsa_pad, :rsa_pkcs1_oaep_padding}])
    )
  end

  def encrypt_data(<<_data::binary>>, _public_key, _acc) do
    raise "Data must be a multple of 214"
  end

  def decrypt_data(data, private_key, acc \\ <<>>)

  def decrypt_data(<<>>, _private_key, acc) do
    acc
  end

  def decrypt_data(<<data_part::binary-size(256), rest::binary>>, private_key, acc) do
    decrypt_data(
      rest,
      private_key,
      acc <>
        :public_key.decrypt_private(data_part, private_key, [{:rsa_pad, :rsa_pkcs1_oaep_padding}])
    )
  end

  def decrypt_data(<<data::binary>>, private_key, acc) do
    acc <> :public_key.decrypt_private(data, private_key, [{:rsa_pad, :rsa_pkcs1_oaep_padding}])
  end
end
