defmodule ExOpcua.Services.OpenSecureChannel do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.BuiltInDataTypes

  @default_cert opc_null_value()

  def decode_response(
        <<_server_proto_ver::int(32), sec_channel_id::int(32), token_id::int(32),
          token_created_at::int(64), revised_lifetime_in_ms::int(32), _nonce::binary>>
      ) do
    {:ok,
     %{
       sec_channel_id: sec_channel_id,
       token_id: token_id,
       token_created_at: BuiltInDataTypes.Timestamp.to_datetime(token_created_at),
       revised_lifetime_in_ms: revised_lifetime_in_ms,
       token_expire_time: DateTime.add(DateTime.utc_now(), revised_lifetime_in_ms, :millisecond)
     }}
  end

  def encode_command(
        security_policy,
        seq_number,
        req_id,
        sender_private_key,
        sender_cert \\ @default_cert,
        reciever_cert \\ @default_cert
      ) do
    nonce =
      System.unique_integer([:positive]) |> Integer.to_string() |> String.pad_leading(32, "0")

    <<
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
      # Security Type 3 = sign and encrypt
      0x03,
      0x00,
      0x00,
      0x00,
      serialize_string(nonce),
      # requested Liftime 3_600_000
      0x80,
      0xEE,
      0x36,
      0x00
    >>
    |> Protocol.wrap_message(
      security_policy,
      sender_private_key,
      sender_cert,
      reciever_cert,
      seq_number,
      req_id
    )
  end
end
