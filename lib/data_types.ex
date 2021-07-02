defmodule ExOpcua.DataTypes do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros

  alias ExOpcua.DataTypes.BuiltInDataTypes.{
    OpcBoolean,
    OpcString,
    Timestamp,
    LocalizedText
  }

  alias ExOpcua.DataTypes.{ExtensionObject, NodeId, QualifiedName}
  def parse_types(<<0x01, rest::binary>>), do: OpcBoolean.take(rest)
  def parse_types(<<0x02, number::int(8), rest::binary>>), do: {number, rest}
  def parse_types(<<0x03, number::uint(8), rest::binary>>), do: {number, rest}
  def parse_types(<<0x04, number::int(16), rest::binary>>), do: {number, rest}
  def parse_types(<<0x05, number::uint(16), rest::binary>>), do: {number, rest}
  def parse_types(<<0x06, number::int(32), rest::binary>>), do: {number, rest}
  def parse_types(<<0x07, number::uint(32), rest::binary>>), do: {number, rest}
  def parse_types(<<0x08, number::int(64), rest::binary>>), do: {number, rest}
  def parse_types(<<0x09, number::uint(64), rest::binary>>), do: {number, rest}
  def parse_types(<<0x0A, number::lfloat, rest::binary>>), do: {number, rest}
  def parse_types(<<0x0B, number::ldouble, rest::binary>>), do: {number, rest}
  def parse_types(<<0x0C, rest::binary>>), do: OpcString.take(rest)
  def parse_types(<<0x0D, rest::binary>>), do: Timestamp.take(rest)
  def parse_types(<<0x0E, guid::binary-size(16), rest::binary>>), do: {guid, rest}
  def parse_types(<<0x0F, rest::binary>>), do: OpcString.take(rest)
  def parse_types(<<0x10, rest::binary>>), do: OpcString.take(rest)
  def parse_types(<<0x11, rest::binary>>), do: NodeId.take(rest)
  def parse_types(<<0x14, rest::binary>>), do: QualifiedName.take(rest)
  def parse_types(<<0x15, rest::binary>>), do: LocalizedText.take(rest)
  def parse_types(<<0x16, rest::binary>>), do: ExtensionObject.take(rest)

  # 22 => UA_NS0ID_STRUCTURE
  # 23 => UA_NS0ID_DATAVALUE
  # 24 => UA_NS0ID_BASEDATATYPE
  # 25 => UA_NS0ID_DIAGNOSTICINFO
  # 26 => UA_NS0ID_NUMBER
  # 27 => UA_NS0ID_INTEGER
  # 28 => UA_NS0ID_UINTEGER
  # 29 => UA_NS0ID_ENUMERATION
  # 30 => UA_NS0ID_IMAGE

  # We have never seen this data type before
  def parse_types(<<type, _rest::binary>>),
    do: raise("Data Type: #{Base.encode16(type)} not implemented")
end
