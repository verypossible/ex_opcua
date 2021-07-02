defmodule ExOpcua.DataTypes.NumericRange do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Signed Software Certificate Parameter Type
    https://reference.opcfoundation.org/v104/Core/DataTypes/SignedSoftwareCertificate/
  """
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

  @type t :: Range.t()

  @doc """
  	Takes in a binary beginning with an User Identity Token
  	Returns a tuple of the User Identity Token and remaining binary
  """
  @spec take(binary()) :: {Range.t(), binary()}
  def take(binary) do
    with {range_data, rest} <- OpcString.take(binary) do
      # Parse range_data
      whatever = 1..8

      {whatever, rest}
    end
  end
end
