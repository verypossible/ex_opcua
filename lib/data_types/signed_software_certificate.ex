defmodule ExOpcua.DataTypes.SignedSoftwareCertificate do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Signed Software Certificate Parameter Type
    https://reference.opcfoundation.org/v104/Core/DataTypes/SignedSoftwareCertificate/
  """
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

  defstruct [
    :certificate_data,
    :signature
  ]

  @type t :: %__MODULE__{
          certificate_data: String.t(),
          signature: String.t()
        }

  @token_types [:anonymous, :username, :cert_x509, :issued_token]

  @doc """
  	Takes in a binary beginning with an User Identity Token
  	Returns a tuple of the User Identity Token and remaining binary
  """
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {:error, binary()}
  def take(binary) do
    with {cert_data, rest} <- OpcString.take(binary),
         {signature, rest} <- OpcString.take(rest) do
      {
        %__MODULE__{
          certificate_data: cert_data,
          signature: signature
        },
        rest
      }
    end
  end
end
