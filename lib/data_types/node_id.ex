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

  defp format_struct(mask, namespace_idx, identifier) do
    %__MODULE__{
      encoding_mask: mask,
      namespace_idx: namespace_idx,
      identifier: identifier
    }
  end

  def take(other_binary), do: {nil, other_binary}

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

  def serialize(thing) do
    IO.inspect(thing)
    :not_implemented
  end
end
