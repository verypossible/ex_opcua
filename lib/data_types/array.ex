defmodule ExOpcua.DataTypes.Array do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros

  @moduledoc """
      Module that contains array encoding and decoding functionality
  """

  @doc """
  	Recieves a binary that begins with an array, and a parsing callback.
      ex:
          iex(1) > DataTypes.Array.take(bin, &DataTypes.NodeId.decode/1)

      Callback function must take a binary as an argument and return a tuple
      of {parsed_data, remaining_binary}

  	Returns a tuple containing a List of array items and remaining binary
  	This is useful for grabbing arrays out of long binary payloads
  """
  @spec take(binary(), function()) :: {list(), binary()}
  def take(<<>>, _), do: {[], <<>>}
  def take(<<opc_null_value(), rest::binary>>, _), do: {[], rest}

  def take(<<array_size::int(32), rest::binary>>, decoder_callback) do
    do_take([], rest, decoder_callback, array_size)
  end

  defp do_take(decoded_list, remaining_binary, _, 0) do
    {Enum.reverse(decoded_list), remaining_binary}
  end

  defp do_take(decoded_list, remaining_binary, decoder_callback, array_size) do
    {decoded_structure, rest} = decoder_callback.(remaining_binary)

    do_take([decoded_structure | decoded_list], rest, decoder_callback, array_size - 1)
  end
end
