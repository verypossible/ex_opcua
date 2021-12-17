defmodule ExOpcua.Services.CloseSession do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.{OpcBoolean, Timestamp}

  def encode_command(_) do
    <<
      0x01,
      0x00,
      473::int(16),
      # request_header
      0x00,
      0x00,
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
      # delete subscriptions
      OpcBoolean.serialize(true)::binary
    >>
  end
end
