defmodule ExOpcua.Services.ActivateSession do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros

  def decode_response(<<
        deserialize_string(_server_nonce),
        # diagnostics and such
        _rest::binary
      >>) do
    {:ok, %{activated: true}}
  end
end
