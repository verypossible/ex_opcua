defmodule ExOpcua.ParameterTypes.UserTokenPolicy do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA User Identity Token Parameter Type
    https://reference.opcfoundation.org/v104/Core/docs/Part4/7.37/
  """
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

  defstruct [
    :policy_id,
    :user_token_type,
    :issued_token_type,
    :issuer_endpoint_url,
    :security_policy_uri
  ]

  @type t :: %__MODULE__{
          policy_id: String.t(),
          user_token_type: atom(),
          issued_token_type: String.t(),
          issuer_endpoint_url: String.t(),
          security_policy_uri: String.t()
        }

  @token_types [:anonymous, :username, :cert_x509, :issued_token]

  # @doc """
  # 	Takes in a User Identity Token and returns the OPCUA binary representation.
  # """

  # @spec encode(any()) :: binary()
  # def encode() do
  # end

  @doc """
  	Takes in a binary beginning with an User Identity Token
  	Returns a tuple of the User Identity Token and remaining binary
  """
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {:error, binary()}
  def take(binary) do
    with {policy_id, rest} <- OpcString.take(binary),
         {token_type, rest} <- take_token_type(rest),
         {issued_token_type, rest} <- OpcString.take(rest),
         {issuer_endpoint_url, rest} <- OpcString.take(rest),
         {sec_policy_uri, rest} <- OpcString.take(rest) do
      {
        %__MODULE__{
          policy_id: policy_id,
          user_token_type: token_type,
          issued_token_type: issued_token_type,
          issuer_endpoint_url: issuer_endpoint_url,
          security_policy_uri: sec_policy_uri
        },
        rest
      }
    end
  end

  defp take_token_type(<<token_type::int(32), rest::binary>>) do
    {Enum.at(@token_types, token_type), rest}
  end
end
