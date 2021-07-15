defmodule ExOpcua.DataTypes.NodeId do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  defstruct [:encoding_mask, :namespace_idx, :identifier]

  @type t :: %__MODULE__{
          encoding_mask: byte(),
          namespace_idx: integer(),
          identifier: any()
        }

  @spec take(binary()) :: {%__MODULE__{}, binary()} | {nil, binary()}
  @doc """
  	Takes in a binary that starts with a NodeID, and returns the node and remaining binary
  	Supported NodeId Encodings are:
    0x00 - 2 byte numeric
    0x01 - four byte numeric
  	0x02 - Numeric (32bit integer)
    0x03 - string value
  	0x04 - GUID
  	0x05 - Opaque (bytestring of variable length)
  """
  def take(<<0x00, identifier::int(8), rest::binary>>) do
    {format_struct(0, nil, identifier), rest}
  end

  def take(<<0x01, namespace_idx::int(8), identifier::int(16), rest::binary>>) do
    {format_struct(1, namespace_idx, identifier), rest}
  end

  def take(<<0x02, namespace_idx::int(16), identifier::int(32), rest::binary>>) do
    {format_struct(2, namespace_idx, identifier), rest}
  end

  def take(<<0x04, namespace_idx::int(16), identifier::bytes-size(16), rest::binary>>) do
    {format_struct(4, namespace_idx, identifier), rest}
  end

  # 0x03 and 0x05 Opaque and String are both bytestring style
  def take(<<mask::int(8), namespace_idx::int(16), deserialize_string(identifier), rest::binary>>)
      when mask in [3, 5] do
    {format_struct(mask, namespace_idx, identifier), rest}
  end

  def take(other_binary), do: {nil, other_binary}

  defp format_struct(mask, namespace_idx, identifier) do
    %__MODULE__{
      encoding_mask: mask,
      namespace_idx: namespace_idx,
      identifier: identifier
    }
  end

  @doc """
    Takes a map of values (Based on the Struct)
    returns an OPCUA binary encoding
    of the structure.
  """
  @spec serialize(map()) :: binary()
  def serialize(%{encoding_mask: 0, identifier: id}), do: <<0::int(8), id::int(8)>>

  def serialize(%{encoding_mask: 1, namespace_idx: idx, identifier: id}) do
    <<1::int(8), idx::int(8), id::int(16)>>
  end

  def serialize(%{encoding_mask: 2, namespace_idx: idx, identifier: id}) do
    <<2::int(8), idx::int(16), id::int(32)>>
  end

  def serialize(%{encoding_mask: 4, namespace_idx: idx, identifier: id}) do
    <<4::int(8), idx::int(16), id::bytes-size(16)>>
  end

  # 0x03 and 0x05 Opaque and String are both bytestring style
  def serialize(%{encoding_mask: mask, namespace_idx: idx, identifier: id}) when mask in [3, 5] do
    <<mask::int(8), idx::int(16), serialize_string(id)>>
  end

  def serialize(_) do
    opc_null_value()
  end

  def to_string(%__MODULE__{
        encoding_mask: 0,
        namespace_idx: _namespace_idx,
        identifier: identifier
      }) do
    "i=" <> Integer.to_string(identifier)
  end

  def to_string(%__MODULE__{
        encoding_mask: mask,
        namespace_idx: namespace_idx,
        identifier: identifier
      })
      when mask in [1, 2] do
    "ns=" <> Integer.to_string(namespace_idx) <> "i=" <> Integer.to_string(identifier)
  end

  def to_string(%__MODULE__{
        encoding_mask: mask,
        namespace_idx: namespace_idx,
        identifier: identifier
      })
      when mask in [3, 5] do
    "ns=" <> Integer.to_string(namespace_idx) <> "i=" <> identifier
  end

  def parse(string) when is_binary(string) do
    string |> String.split(";") |> Enum.reduce(%__MODULE__{}, &do_parse/2)
  end

  defp do_parse("ns=" <> namespace_idx, %__MODULE__{} = nodeID) do
    {namespace_idx, _} = Integer.parse(namespace_idx)
    Map.put(nodeID, :namespace_idx, namespace_idx)
  end

  defp do_parse("i=" <> integer_identifier, %__MODULE__{} = nodeID) do
    {identifier, _} = Integer.parse(integer_identifier)

    nodeID
    |> Map.put(:encoding_mask, 2)
    |> Map.put(:identifier, identifier)
  end

  defp do_parse("s=" <> string_identifier, %__MODULE__{} = nodeID) do
    nodeID
    |> Map.put(:encoding_mask, 3)
    |> Map.put(:identifier, string_identifier)
  end

  defp do_parse("g=" <> guid_identifier, %__MODULE__{} = nodeID) do
    # TODO: Guids are 16 bytes, but currently there is no conversion from string representation
    raise "Guid String Parsing not yet implemented"
  end
end
