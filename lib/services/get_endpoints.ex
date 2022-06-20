defmodule ExOpcua.Services.GetEndpoints do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.Array
  alias ExOpcua.DataTypes.EndpointDescription
  alias ExOpcua.DataTypes.BuiltInDataTypes.{OpcString, Timestamp}

  @default_transport_proto "http://opcfoundation.org/UA-Profile/Transport/uatcp-uasc-uabinary"

  def decode_response(binary) do
    with {endpoints, _} <- Array.take(binary, &EndpointDescription.take/1) do
      {:ok, %{endpoints: endpoints}}
    end
  end

  def encode_command(%{
        url: url
      }) do
    <<
      0x01,
      0x00,
      428::int(16),
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
      serialize_string(url),
      Array.serialize([@default_transport_proto], &OpcString.serialize/1)::binary,
      Array.serialize([@default_transport_proto], &OpcString.serialize/1)::binary
    >>
  end
end
