defmodule ExOpcua.Services.OpenSecureChannel do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes

  @message_type "OPN"
  @is_final "F"
  @default_cert opc_null_value()

  def decode_response(
        <<_server_proto_ver::int(32), sec_channel_id::int(32),
          token_id::int(32), token_created_at::int(64),
          revised_lifetime_in_ms::int(32), _nonce::binary>>
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

  def encode_command(security_policy, seq_number, req_id) do
    payload = <<
      # channel_id
      0::int(32),
      serialize_string(security_policy),
      # sender cert
      @default_cert,
      # reciever cert
      @default_cert,
      # sequence number
      seq_number::int(32),
      # request id
      req_id::int(32),
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
      @message_type::binary,
      @is_final::binary,
      msg_size::int(32)
    >> <> payload
  end
end
