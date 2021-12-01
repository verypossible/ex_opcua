defmodule ExOpcua.Services.GetEndpoints do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.{Array, NodeId}
  alias ExOpcua.ParameterTypes.EndpointDescription
  alias ExOpcua.DataTypes.BuiltInDataTypes.{OpcString, Timestamp}

  @default_transport_proto "http://opcfoundation.org/UA-Profile/Transport/uatcp-uasc-uabinary"

  def decode_response(binary) do
    with {endpoints, _} <- Array.take(binary, &EndpointDescription.take/1) do
      {:ok, %{endpoints: endpoints}}
    end
  end

  def encode_command(%{
        url: url,
        sec_channel_id: sec_channel_id,
        token_id: token_id,
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
    |> Protocol.prepend_message_header()
  end
end
