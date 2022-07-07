defmodule ExOpcua.Services.CreateSession do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.{Array, EndpointDescription, NodeId}
  alias ExOpcua.ParameterTypes.ApplicationDescription
  alias ExOpcua.DataTypes.BuiltInDataTypes.{OpcString, Timestamp}

  def decode_response(bin_response) when is_binary(bin_response) do
    with {session_id, rest} <- NodeId.take(bin_response),
         {auth_token, rest} <- NodeId.take(rest),
         {revised_session_timeout, rest} <- take_revised_timeout(rest),
         {server_nonce, rest} <- OpcString.take(rest),
         {server_cert, rest} <- OpcString.take(rest),
         {endpoint_descriptions, _rest} <- Array.take(rest, &EndpointDescription.take/1) do
      {
        :ok,
        %{
          session_id: session_id,
          auth_token: auth_token,
          revised_session_timeout: round(revised_session_timeout),
          server_session_signature: server_cert <> server_nonce,
          session_expire_time:
            DateTime.add(DateTime.utc_now(), revised_session_timeout, :millisecond),
          endpoint_descriptions: endpoint_descriptions
        }
      }
    end
  end

  def encode_command(%{url: url, security_profile: sec_profile}) do
    <<
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
      serialize_string(String.replace(url, "/", ":")),
      serialize_string(url),
      # session name
      serialize_string("Helios Session" <> "#{System.unique_integer([:positive])}"),
      # client nonce
      serialize_string(:crypto.strong_rand_bytes(32)),
      # client cert
      OpcString.serialize(sec_profile.client_pub_key)::binary,
      # requested keepalive
      300_000::little-float-size(64),
      0::int(32)
    >>
  end

  defp take_revised_timeout(<<revised_session_timeout::ldouble, rest::binary>>) do
    {round(revised_session_timeout), rest}
  end
end
