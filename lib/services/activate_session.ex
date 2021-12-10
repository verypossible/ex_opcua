defmodule ExOpcua.Services.ActivateSession do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.NodeId
  alias ExOpcua.DataTypes.BuiltInDataTypes.{OpcString, Timestamp}

  def decode_response(<<
        deserialize_string(_server_nonce),
        # diagnostics and such
        _rest::binary
      >>) do
    {:ok, %{activated: true}}
  end

  def decode_response(binary) do
    IO.inspect(Base.encode16(binary))
    {:ok, %{activated: true}}
  end

  def encode_command(%{auth_token: auth_token, session_signature: signature}) do
    <<
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
      OpcString.serialize("http://www.w3.org/2001/04/xmldsig-more#rsa-sha256")::binary,
      OpcString.serialize(signature)::binary,
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
    |> IO.inspect(limit: :infinity)
  end
end
