defmodule ExOpcua.ParameterTypes.EndpointDescription do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Endpoint Description Parameter Type
  	https://reference.opcfoundation.org/v104/Core/docs/Part4/7.10/
  """
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString
  alias ExOpcua.DataTypes.Array
  alias ExOpcua.ParameterTypes.{ApplicationDescription, UserTokenPolicy}

  defstruct [
    :url,
    :server,
    :server_cert,
    :message_sec_mode,
    :sec_policy_uri,
    :user_id_tokens,
    :transport_profile_uri,
    :security_level
  ]

  @type t :: %__MODULE__{
          url: String.t(),
          server: ApplicationDescription.t(),
          server_cert: binary(),
          message_sec_mode: atom(),
          sec_policy_uri: String.t(),
          user_id_tokens: [any()],
          transport_profile_uri: String.t(),
          security_level: integer()
        }

  @security_modes [:invalid, :none, :sign, :sign_and_encrypt]

  @doc """
  	Takes in a binary beginning with an Endpoint Description
  	Returns a tuple of the Endpoint Description and remaining binary
  """
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {:error, binary()}
  def take(binary) do
    with {endpoint_url, rest} <- OpcString.take(binary),
         {server, rest} <- ApplicationDescription.take(rest),
         {server_cert, rest} <- OpcString.take(rest),
         {message_sec_mode, rest} <- take_sec_mode(rest),
         {sec_policy_uri, rest} <- OpcString.take(rest),
         {user_id_tokens, rest} <- Array.take(rest, &UserTokenPolicy.take/1),
         {transport_profile_uri, rest} <- OpcString.take(rest),
         <<security_level::int(8), rest::binary>> <- rest do
      server_cert =
        case X509.Certificate.from_der(server_cert) do
          {:ok, parsed_server_cert} ->
            %{
              public_key: X509.Certificate.public_key(parsed_server_cert),
              thumprint: :crypto.hash(:sha, server_cert)
            }

          _ ->
            nil
        end

      {
        %__MODULE__{
          url: endpoint_url,
          server: server,
          server_cert: server_cert,
          message_sec_mode: message_sec_mode,
          sec_policy_uri: sec_policy_uri,
          user_id_tokens: user_id_tokens,
          transport_profile_uri: transport_profile_uri,
          security_level: security_level
        },
        rest
      }
    end
  end

  defp take_sec_mode(<<sec_mode::int(32), rest::binary>>) do
    {Enum.at(@security_modes, sec_mode), rest}
  end
end
