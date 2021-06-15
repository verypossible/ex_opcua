defmodule ExOpcua.Services.CreateSession do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{Array, NodeId, SignedSoftwareCertificate}
  alias ExOpcua.ParameterTypes.EndpointDescription
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

  def decode_response(bin_response) when is_binary(bin_response) do
    with {session_id, rest} <- NodeId.take(bin_response),
         {auth_token, rest} <- NodeId.take(rest),
         {revised_session_timeout, rest} <- take_revised_timeout(rest),
         {_server_nonce, rest} <- OpcString.take(rest),
         {server_cert, rest} <- OpcString.take(rest),
         {endpoint_descriptions, rest} <- Array.take(rest, &EndpointDescription.take/1),
         {server_software_certs, rest} <- Array.take(rest, &SignedSoftwareCertificate.take/1),
         {_signature_algorithm, rest} <- OpcString.take(rest),
         {_signature, rest} <- OpcString.take(rest) do
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

  defp take_revised_timeout(<<revised_session_timeout::little-float-size(64), rest::binary>>) do
    {round(revised_session_timeout), rest}
  end
end
