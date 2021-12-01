defmodule ExOpcua.Services.ActivateSession do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.NodeId
  alias ExOpcua.DataTypes.BuiltInDataTypes.Timestamp

  def decode_response(<<
        deserialize_string(_server_nonce),
        # diagnostics and such
        _rest::binary
      >>) do
    {:ok, %{activated: true}}
  end

  def encode_command(%{
        sec_channel_id: sec_channel_id,
        token_id: token_id,
        auth_token: auth_token,
        req_id: req_id,
        seq_number: seq_number
      }) do
    <<
      sec_channel_id::int(32),
      token_id::int(32),
      seq_number::int(32),
      req_id::int(32),
      0x01,
      0x00,
      467::int(16),
      # request_header
      NodeId.serialize(auth_token)::binary,
      # timestamp
      Timestamp.from_datetime(DateTime.utc_now())::int(64),
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
      # client_signiture
      opc_null_value(),
      opc_null_value(),
      # empty array of certs
      opc_null_value(),
      # array of locales
      1::int(32),
      2::int(32),
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
      serialize_string("anonymous"),
      # signature data
      opc_null_value(),
      opc_null_value()
    >>
    |> Protocol.prepend_message_header()
  end
end
