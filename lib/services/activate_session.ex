defmodule ExOpcua.Services.ActivateSession do
  require ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes

  def decode_response(<<
        BuiltInDataTypes.Macros.deserialize_string(_server_nonce),
        # diagnostics and such
        _rest::binary
      >>) do
    :ok
  end
end
