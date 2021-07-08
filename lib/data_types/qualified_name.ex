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

  def serialize(%{id: id, name: name}) when is_binary(name) do
    <<id::int(16), OpcString.serialize(name)::binary>>
  end

  def serialize(_) do
    <<0::int(16), opc_null_value()>>
  end
end
