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
  alias ExOpcua.Protocol.{Headers, Services, DataTypes}
  # 0xFF 0xFF 0xFF 0xFF
  @default_cert 4_294_967_295
  @default_version 0
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

  @spec recieve_message(pid(), integer() | nil, binary()) ::
          {:ok, %{payload: any, header: struct()}} | {:error, atom()}
  def recieve_message(socket, size \\ nil, message_acc \\ <<>>)

  def recieve_message(socket, nil, <<>>) do
    {:ok, <<msg_type::bytes-size(3), rest::binary>> = whole_message} =
      :gen_tcp.recv(socket, 0, 10_000)

    {%{msg_size: size}, _} =
      msg_type
      |> decode_message_type()
      |> Headers.decode_message_header(rest)

    recieve_message(socket, size, whole_message)
  end

  def recieve_message(socket, size, message_acc)
      when is_integer(size) and byte_size(message_acc) < size do
    {:ok, more_message} = :gen_tcp.recv(socket, 0, 10_000)

    recieve_message(socket, size, message_acc <> more_message)
  end

  def recieve_message(_socket, size, message_acc)
      when is_integer(size) do
    decode_recieved(message_acc)
  end

  @spec decode_recieved(binary()) ::
          {:ok, %{payload: any, header: struct()}} | {:error, atom()}
  def decode_recieved(<<msg_type::bytes-size(3), rest::binary>>) do
    msg_type
    |> decode_message_type()
    |> Headers.decode_message_header(rest)
    |> decode_message()
  end

  @spec encode_message(atom(), [any]) :: binary() | :error
  def encode_message(:hello, %{url: url}) do
    url_size = byte_size(url)
    # messages without URL are 32 bytes
    msg_size = 32 + url_size

    <<
      @message_types[:hello]::binary,
      @is_final[:final]::binary,
      msg_size::little-integer-size(32),
      @default_version::integer-size(32),
      # rec_buff_size
      147_456::little-integer-size(32),
      # send_buff_size
      147_456::little-integer-size(32),
      # max_msg_size
      4_194_240::little-integer-size(32),
      # max_chunk_count
      65535::little-integer-size(32),
      url_size::little-integer-size(32),
      url::binary
    >>
  end

  def encode_message(:open_secure_channel, %{sec_policy: security_policy}) do
    security_policy_size = byte_size(security_policy)
    seq_number = 5

    payload = <<
      # channel_id
      0::little-integer-size(32),
      security_policy_size::little-integer-size(32),
      security_policy::binary,
      # sender cert
      @default_cert::little-integer-size(32),
      # reciever cert
      @default_cert::little-integer-size(32),
      # sequence number
      seq_number::little-integer-size(32),
      # request id
      1::little-integer-size(32),
      # request message
      0x01,
      0x00,
      0xBE,
      0x01,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x80,
      0xEE,
      0x36,
      0x00
    >>

    msg_size = 8 + byte_size(payload)

    <<
      @message_types[:open_secure_channel]::binary,
      @is_final[:final]::binary,
      msg_size::little-integer-size(32)
    >> <> payload
  end

  def encode_message(:open_session, %{
        sec_channel_id: sec_channel_id,
        token_id: token_id,
        url: url
      }) do
    url = "opc.tcp://Kalebs-MacBook-Pro.local:53530/OPCUA/SimulationServer"
    url_size = byte_size(url)
    next_sequence_num = 6

    payload = <<
      sec_channel_id::little-integer-size(32),
      token_id::little-integer-size(32),
      next_sequence_num::little-integer-size(32),
      next_sequence_num::little-integer-size(32),
      0x01,
      0x00,
      461::little-integer-size(16),
      # request_header
      0x00,
      0x00,
      # timestamp
      DataTypes.datetime_to_timestamp(DateTime.utc_now())::little-integer-size(64),
      # request handle and diagnostics
      0::little-integer-size(64),
      # audit entry id
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      # timeout hint
      0::little-integer-size(32),
      # additional header
      0x00,
      0x00,
      0x00,
      # product_description
      42::little-integer-size(32),
      "urn:Kalebs-MacBook-Pro.local:helios_nerves",
      32::little-integer-size(32),
      "urn:helios-app.com:helios_nerves",
      # localized name
      0x03,
      0x00,
      0x00,
      0x00,
      0x00,
      13::little-integer-size(32),
      "helios_nerves",
      # application type client
      1::little-integer-size(32),
      # additional null values 0xFF
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      # ServerURI
      51::little-integer-size(32),
      "urn:Kalebs-MacBook-Pro.local:OPCUA:SimulationServer",
      url_size::little-integer-size(32),
      url::binary,
      # session name
      16::little-integer-size(32),
      "Helios Session12",
      # client nonce
      32::little-integer-size(32),
      System.unique_integer()::little-integer-size(256),
      # client cert
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      # requested keepalive
      300_000::little-float-size(64),
      0::little-integer-size(32)
    >>

    msg_size = 8 + byte_size(payload)

    <<
      @message_types[:message]::binary,
      @is_final[:final]::binary,
      msg_size::little-integer-size(32)
    >> <> payload
  end

  def encode_message(:activate_session, %{
        sec_channel_id: sec_channel_id,
        token_id: token_id,
        auth_token: auth_token
      }) do
    next_sequence_num = 7

    payload = <<
      sec_channel_id::little-integer-size(32),
      token_id::little-integer-size(32),
      next_sequence_num::little-integer-size(32),
      next_sequence_num::little-integer-size(32),
      0x01,
      0x00,
      467::little-integer-size(16),
      # request_header
      auth_token::binary,
      # timestamp
      DataTypes.datetime_to_timestamp(DateTime.utc_now())::little-integer-size(64),
      # request handle and diagnostics
      0::little-integer-size(64),
      # audit entry id
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      # timeout hint
      0::little-integer-size(32),
      # additional header
      0x00,
      0x00,
      0x00,
      # client_signiture
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      # empty array of certs
      0::little-integer-size(32),
      # array of locales
      1::little-integer-size(32),
      2::little-integer-size(32),
      "en",
      # client identity (ANONYMOUS)
      0x01,
      0x00,
      0x41,
      0x01,
      0x01,
      0x0D,
      0x00,
      0x00,
      0x00,
      0x09,
      0x00,
      0x00,
      0x00,
      0x41,
      0x6E,
      0x6F,
      0x6E,
      0x79,
      0x6D,
      0x6F,
      0x75,
      0x73,
      # signature data
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF
    >>

    msg_size = 8 + byte_size(payload)

    <<
      @message_types[:message]::binary,
      @is_final[:final]::binary,
      msg_size::little-integer-size(32)
    >> <> payload
  end

  def encode_message(_, _) do
    :not_implemented
  end

  @spec decode_message({struct(), binary() | <<>>} | {:error, atom()}) ::
          {:ok, %{payload: any, header: struct()}} | {:error, atom()}
  def decode_message({header, <<>>}) do
    {:ok, %{header: header, payload: nil}}
  end

  def decode_message({header, bin_message}) do
    case Services.decode(bin_message) do
      {:ok, decoded_message} -> {:ok, %{header: header, payload: decoded_message}}
      {:error, reason} -> {:error, reason}
      _ -> {:error, :undefined_error}
    end
  end

  def decode_message(_) do
    {:error, :invalid_input}
  end

  @spec decode_message_type(binary()) :: atom() | nil
  def decode_message_type("ACK"), do: :ack
  def decode_message_type("ERR"), do: :error_msg
  def decode_message_type("OPN"), do: :open_secure_channel
  def decode_message_type("MSG"), do: :message
  def decode_message_type(_), do: nil
end
