defmodule ExOpcua.Services.CreateSession do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.{Array, NodeId, SignedSoftwareCertificate}
  alias ExOpcua.ParameterTypes.{ApplicationDescription, EndpointDescription}
  alias ExOpcua.DataTypes.BuiltInDataTypes.{OpcString, Timestamp}

  def decode_response(bin_response) when is_binary(bin_response) do
    with {session_id, rest} <- NodeId.take(bin_response),
         {auth_token, rest} <- NodeId.take(rest),
         {revised_session_timeout, rest} <- take_revised_timeout(rest),
         {_server_nonce, rest} <- OpcString.take(rest),
         {server_cert, rest} <- OpcString.take(rest),
         {endpoint_descriptions, rest} <- Array.take(rest, &EndpointDescription.take/1),
         {server_software_certs, rest} <- Array.take(rest, &SignedSoftwareCertificate.take/1),
         {_signature_algorithm, rest} <- OpcString.take(rest),
         {_signature, _rest} <- OpcString.take(rest) do
      {
        :ok,
        %{
          session_id: session_id,
          auth_token: auth_token,
          revised_session_timeout: round(revised_session_timeout),
          server_cert: server_cert,
          session_expire_time:
            DateTime.add(DateTime.utc_now(), revised_session_timeout, :millisecond),
          endpoint_descriptions: endpoint_descriptions,
          server_software_certs: server_software_certs
        }
      }
    end
  end

  def encode_command(%{
        sec_channel_id: sec_channel_id,
        token_id: token_id,
        req_id: req_id,
        seq_number: seq_number,
        url: url
      }) do
    url = "opc.tcp://Kalebs-MacBook-Pro.local:53530/OPCUA/SimulationServer"

    <<
      sec_channel_id::int(32),
      token_id::int(32),
      seq_number::int(32),
      # request_id
      req_id::int(32),
      0x01,
      0x00,
      461::int(16),
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
      # product_description
      ApplicationDescription.serialize()::binary,
      # ServerURI
      serialize_string("urn:Kalebs-MacBook-Pro.local:OPCUA:SimulationServer"),
      serialize_string(url),
      # session name
      serialize_string("Helios Session12"),
      # client nonce
      32::int(32),
      System.unique_integer()::int(256),
      # client cert
      opc_null_value(),
      # requested keepalive
      300_000::little-float-size(64),
      0::int(32)
    >>
    |> Protocol.append_message_header()
  end

  defp take_revised_timeout(<<revised_session_timeout::ldouble, rest::binary>>) do
    {round(revised_session_timeout), rest}
  end
end
