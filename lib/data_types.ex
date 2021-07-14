defmodule ExOpcua.DataTypes do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros

  alias ExOpcua.DataTypes.BuiltInDataTypes.{
    OpcBoolean,
    OpcString,
    Timestamp,
    LocalizedText
  }

  alias ExOpcua.DataTypes.{Array, ExtensionObject, NodeId, QualifiedName}

  @doc """
    Takes a binary, and infers the datatype based on the first byte
    This is useful for variants that label datatypes with a leading byte
  """
  @spec take_data_type(binary()) :: {any(), binary()}
  def take_data_type(<<type_byte, rest::binary>>) do
    inferred_type = infer_datatype(type_byte)

    if inferred_type == type_byte do
      take_variant(type_byte, rest)
    else
      take_data_type(inferred_type, rest)
    end
  end

  def take_variant(type_byte, rest) do
    <<value_array::size(1)-unit(1), dimension_array::size(1)-unit(1), type::uint(6),
      rest::binary>> = <<type_byte>> <> rest

    # TODO: handle value_array, dimension_array, types
    case {value_array, dimension_array} do
      {1, 1} -> IO.inspect("value_array = True, dimension_array = True")
      {1, 0} -> IO.inspect("value_array = True, dimension_array = False")
      {0, 1} -> IO.inspect("value_array = False, dimension_array = True")
      {0, 0} -> IO.inspect("value_array = False, dimension_array = False")
    end

    type_byte
    |> infer_variant()
    |> take_variant_type(rest)

    # Array.take(rest, &take_data_type(infer_datatype(type_byte), &1))
  end

  defp take_variant_type(:ARRAY_OF_STRINGS, bin), do: Array.take(bin, &OpcString.take/1)
  defp infer_variant(0x8C), do: :ARRAY_OF_STRINGS

  @doc """
    Takes an atom that represents which datatype to parse and a binary
    returns a tuple with the data type parsed into a native format and the remaining binary
  """
  @spec take_data_type(atom(), binary()) :: {any(), binary()}
  def take_data_type(:UA_NULL, bin), do: {nil, bin}
  def take_data_type(:UA_BOOL, bin), do: OpcBoolean.take(bin)
  def take_data_type(:UA_INT8, <<number::int(8), rest::binary>>), do: {number, rest}
  def take_data_type(:UA_UINT8, <<number::uint(8), rest::binary>>), do: {number, rest}
  def take_data_type(:UA_INT16, <<number::int(16), rest::binary>>), do: {number, rest}
  def take_data_type(:UA_UINT16, <<number::uint(16), rest::binary>>), do: {number, rest}
  def take_data_type(:UA_INT32, <<number::int(32), rest::binary>>), do: {number, rest}
  def take_data_type(:UA_UINT32, <<number::uint(32), rest::binary>>), do: {number, rest}
  def take_data_type(:UA_INT64, <<number::int(64), rest::binary>>), do: {number, rest}
  def take_data_type(:UA_UINT64, <<number::uint(64), rest::binary>>), do: {number, rest}
  def take_data_type(:UA_FLOAT, <<number::lfloat, rest::binary>>), do: {number, rest}
  def take_data_type(:UA_DOUBLE, <<number::ldouble, rest::binary>>), do: {number, rest}
  def take_data_type(:UA_STRING, bin), do: OpcString.take(bin)
  def take_data_type(:UA_TIMESTAMP, bin), do: Timestamp.take(bin)
  def take_data_type(:UA_GUID, <<guid::binary-size(16), rest::binary>>), do: {guid, rest}
  def take_data_type(:UA_BYTESTRING, bin), do: OpcString.take(bin)
  def take_data_type(:UA_XML_ELEMENT, bin), do: OpcString.take(bin)
  def take_data_type(:UA_NODE_ID, bin), do: NodeId.take(bin)
  def take_data_type(:UA_EXPANDED_NODE_ID, bin), do: QualifiedName.take(bin)
  def take_data_type(:UA_LOCALIZED_TEXT, bin), do: LocalizedText.take(bin)
  def take_data_type(:UA_EXTENSION_OBJ, bin), do: ExtensionObject.take(bin)

  # We have never seen this data type before
  def take_data_type(type, _), do: raise("Data Type: #{inspect(type)} not implemented")

  defp infer_datatype(0x00), do: :UA_NULL
  defp infer_datatype(0x01), do: :UA_BOOL
  defp infer_datatype(0x02), do: :UA_INT8
  defp infer_datatype(0x03), do: :UA_UINT8
  defp infer_datatype(0x04), do: :UA_INT16
  defp infer_datatype(0x05), do: :UA_UINT16
  defp infer_datatype(0x06), do: :UA_INT32
  defp infer_datatype(0x07), do: :UA_UINT32
  defp infer_datatype(0x08), do: :UA_INT64
  defp infer_datatype(0x09), do: :UA_UINT64
  defp infer_datatype(0x0A), do: :UA_FLOAT
  defp infer_datatype(0x0B), do: :UA_DOUBLE
  defp infer_datatype(0x0C), do: :UA_STRING
  defp infer_datatype(0x0D), do: :UA_TIMESTAMP
  defp infer_datatype(0x0E), do: :UA_GUID
  defp infer_datatype(0x0F), do: :UA_BYTESTRING
  defp infer_datatype(0x10), do: :UA_XML_ELEMENT
  defp infer_datatype(0x11), do: :UA_NODE_ID
  defp infer_datatype(0x14), do: :UA_EXPANDED_NODE_ID
  defp infer_datatype(0x15), do: :UA_LOCALIZED_TEXT
  defp infer_datatype(0x16), do: :UA_EXTENSION_OBJ

  # 22 => UA_NS0ID_STRUCTURE
  # 23 => UA_NS0ID_DATAVALUE
  # 24 => UA_NS0ID_BASEDATATYPE
  # 25 => UA_NS0ID_DIAGNOSTICINFO
  # 26 => UA_NS0ID_NUMBER
  # 27 => UA_NS0ID_INTEGER
  # 28 => UA_NS0ID_UINTEGER
  # 29 => UA_NS0ID_ENUMERATION
  # 30 => UA_NS0ID_IMAGE

  defp infer_datatype(type), do: type
end
