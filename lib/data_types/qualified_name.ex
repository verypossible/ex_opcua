defmodule ExOpcua.DataTypes.QualifiedName do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Signed Software Certificate Parameter Type
    https://reference.opcfoundation.org/v104/Core/DataTypes/SignedSoftwareCertificate/
  """
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros

  defstruct [
    :id,
    :name
  ]

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }

  @spec take(binary()) :: {__MODULE__.t(), binary()}
  def take(<<opc_null_value(), rest::binary>>) do
    {nil, rest}
  end

  def take(<<id::int(16), rest::binary>>) do
    {name, rest} = OpcString.take(rest)

    {%__MODULE__{id: id, name: name}, rest}
  end
end
