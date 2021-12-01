defmodule ExOpcua.Services.CloseSecureChannel do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.BuiltInDataTypes

  def encode_command(token_id, sci, seq_number, req_id) do
    <<
      # channel_id
      sci::int(32),
      token_id::int(32),
      # sequence number
      seq_number::int(32),
      # request id
      req_id::int(32),
      0x01,
      0x00,
      0xC4,
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
      0x00
    >>
    |> Protocol.prepend_message_header(:final, :close_secure_channel)
  end
end
