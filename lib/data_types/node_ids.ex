defmodule ExOpcua.DataTypes.NodeIds do
  defmodule NodeId do
    defstruct [:encoding_mask, :namespace_idx, :identifier, :raw_binary]
  end

  @spec take(binary()) :: {%NodeId{}, binary()} | {nil, binary()}
  @doc """
  	Takes in a binary that starts with a NodeID, and returns the node and remaining binary
  	Supported NodeId Encodings are:
  	0x02 - Numeric (32bit integer)
  	0x04 - GUID
  	0x05 - Opaque (bytestring of variable length)
  """
  def take(
        <<0x02, namespace_idx::little-integer-size(16), identifier::little-integer-size(32),
          rest::binary>>
      ) do
    {%NodeId{
       encoding_mask: 0x02,
       namespace_idx: namespace_idx,
       identifier: identifier,
       raw_binary:
         <<0x02, namespace_idx::little-integer-size(16), identifier::little-integer-size(32)>>
     }, rest}
  end

  def take(
        <<0x04, namespace_idx::little-integer-size(16), identifier::bytes-size(16), rest::binary>>
      ) do
    {%NodeId{
       encoding_mask: 0x04,
       namespace_idx: namespace_idx,
       identifier: identifier,
       raw_binary: <<0x04, namespace_idx::little-integer-size(16), identifier::bytes-size(16)>>
     }, rest}
  end

  def take(
        <<0x05, namespace_idx::little-integer-size(16), identifier_size::little-integer-size(32),
          identifier::bytes-size(identifier_size), rest::binary>>
      ) do
    {%NodeId{
       encoding_mask: 0x05,
       namespace_idx: namespace_idx,
       identifier: identifier,
       raw_binary:
         <<0x05, namespace_idx::little-integer-size(16), identifier_size::little-integer-size(32),
           identifier::bytes-size(identifier_size)>>
     }, rest}
  end

  def take(other_binary), do: {nil, other_binary}
end
