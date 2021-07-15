defmodule ExOpcua.DataTypes.NumericRange do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Numeric Range Data Type
    https://reference.opcfoundation.org/v104/Core/docs/Part4/7.22/
  """
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

  @type t :: Range.t()

  @spec take(binary()) :: {Range.t(), binary()}
  def take(binary) do
    with {range_data, rest} <- OpcString.take(binary) do
      range =
        range_data
        |> String.split(",")
        |> range()

      {range, rest}
    end
  end

  def range(ranges) when length(ranges) > 1 do
    # Unclear how to implement “1:2,0:1”
    raise "Multi-Range not implemented"
  end

  def range(range) when length(range) == 1 do
    case String.contains?(range, ":") do
      true ->
        [min, max] = String.split(range, ":")

        if min < max do
          min..max
        else
          raise "Bad_IndexRangeNoData"
        end

      false ->
        String.to_integer(range)
    end
  end
end
