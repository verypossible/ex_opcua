defmodule ExOpcua.Services.OpenSecureChannel do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.SecurityProfile
  alias ExOpcua.DataTypes.BuiltInDataTypes.{OpcString, Timestamp}

  @securtiy_type_enum [invalid: 0, none: 1, sign: 2, sign_encrypt: 3]

  def decode_response(
        <<_server_proto_ver::int(32), sec_channel_id::int(32), token_id::int(32),
          token_created_at::int(64), revised_lifetime_in_ms::int(32), deserialize_string(nonce),
          _rest::binary>>
      ) do
    {:ok,
     %{
       sec_channel_id: sec_channel_id,
       token_id: token_id,
       token_created_at: Timestamp.to_datetime(token_created_at),
       revised_lifetime_in_ms: revised_lifetime_in_ms,
       token_expire_time: DateTime.add(DateTime.utc_now(), revised_lifetime_in_ms, :millisecond),
       server_nonce: nonce
     }}
  end

  def encode_command(%SecurityProfile{} = security_profile) do
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
      @securtiy_type_enum[security_profile.sec_mode]::int(32),
      OpcString.serialize(security_profile.client_nonce)::binary,
      # requested Liftime 3_600_000
      0x80,
      0xEE,
      0x36,
      0x00
    >>
  end
end
