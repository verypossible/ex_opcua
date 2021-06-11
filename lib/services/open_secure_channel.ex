defmodule ExOpcua.Services.OpenSecureChannel do
  require ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes

  @message_type "OPN"
  @is_final "F"
  # 0xFF 0xFF 0xFF 0xFF
  @default_cert 4_294_967_295

  def decode_response(
        <<_server_proto_ver::little-integer-size(32), sec_channel_id::little-integer-size(32),
          token_id::little-integer-size(32), token_created_at::little-integer-size(64),
          revised_lifetime_in_ms::little-integer-size(32), _nonce::binary>>
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
      0::little-integer-size(32),
      BuiltInDataTypes.Macros.serialize_string(security_policy),
      # sender cert
      @default_cert::little-integer-size(32),
      # reciever cert
      @default_cert::little-integer-size(32),
      # sequence number
      seq_number::little-integer-size(32),
      # request id
      req_id::little-integer-size(32),
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
      msg_size::little-integer-size(32)
    >> <> payload
  end
end
