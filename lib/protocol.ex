defmodule ExOpcua.Protocol do
  @moduledoc """
  Documentation for `ExOpcua.Protocol`.
  """

  @doc """
  This Module provides decode and encode functions for OPC UA comms

  ## Examples

      iex> ExOpcua.decode("ACK")
      :ack

  """
  alias ExOpcua.Protocol.{Headers, Services}
  # F
  @default_chunk_type 0x46
  # 0xFF 0xFF 0xFF 0xFF
  @default_cert 4_294_967_295
  @default_version 0
  @message_types [
    hello: "HEL",
    open_secure_channel: "OPN",
    close_secure_channel: "CLO",
    message: "MSG"
  ]

  @spec decode_recieved(binary()) :: [any] | :error
  def decode_recieved(<<msg_type::bytes-size(3), rest::binary>>) do
    {header, rest} =
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
      encode_message_type(:hello)::binary,
      @default_chunk_type,
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
      30::little-integer-size(32),
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
      encode_message_type(:open_secure_channel)::binary,
      @default_chunk_type,
      msg_size::little-integer-size(32)
    >> <> payload
  end

  @spec encode_message_type(atom()) :: String.t() | nil
  def encode_message_type(type) when is_atom(type), do: Keyword.get(@message_types, type)

  @spec decode_message({struct(), binary() | <<>>} | {:error, atom()}) ::
          {:ok, %{message: any, header: struct()}} | {:error, atom()}
  def decode_message({header, <<>>}) do
    {:ok, %{header: header, message: nil}}
  end

  def decode_message({header, bin_message}) do
    case Services.decode(bin_message) do
      {:ok, decoded_message} -> {:ok, %{header: header, message: decoded_message}}
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
