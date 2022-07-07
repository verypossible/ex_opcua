defmodule ExOpcua.DataTypes.NodeId do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

  # Default is NODEID_UA_ROOT
  defstruct [
    :server_idx,
    :server_uri,
    encoding_mask: 2,
    namespace_idx: 0,
    identifier: 84
  ]

  @type t :: %__MODULE__{
          encoding_mask: integer(),
          namespace_idx: integer(),
          identifier: any(),
          server_idx: integer(),
          server_uri: binary()
        }

  @default_objects_dir "ns=0;i=85"

  def objects_dir(), do: @default_objects_dir

  @spec take(binary()) :: {%__MODULE__{}, binary()} | {nil, binary()}
  @doc """
    Takes in a binary that starts with a NodeID, and returns the node and remaining binary
    Encodings are split into 4bit masks

    First 4 bits represents "has server index" or "has namespace uri"
      0x4 has service_index
      0x8 has namespace_uri
      0xC has both

    Second 4 bits represent encoding
      0x0 - 2 byte numeric
      0x1 - four byte numeric
      0x2 - Numeric (32bit integer)
      0x3 - string value
      0x4 - GUID
      0x5 - Opaque (bytestring of variable length)

  """
  def take(<<has_additional::uint(4), 0::uint(4), identifier::int(8), rest::binary>>) do
    take_additional(has_additional, 0, nil, identifier, rest)
  end

  def take(
        <<has_additional::uint(4), 1::uint(4), namespace_idx::int(8), identifier::int(16),
          rest::binary>>
      ) do
    take_additional(has_additional, 1, namespace_idx, identifier, rest)
  end

  def take(
        <<has_additional::uint(4), 2::uint(4), namespace_idx::int(16), identifier::int(32),
          rest::binary>>
      ) do
    take_additional(has_additional, 2, namespace_idx, identifier, rest)
  end

  def take(
        <<has_additional::uint(4), 4::uint(4), namespace_idx::int(16), identifier::bytes-size(16),
          rest::binary>>
      ) do
    take_additional(has_additional, 4, namespace_idx, identifier, rest)
  end

  # 0x03 and 0x05 Opaque and String are both bytestring style
  def take(
        <<has_additional::uint(4), mask::uint(4), namespace_idx::int(16),
          deserialize_string(identifier), rest::binary>>
      )
      when mask in [3, 5] do
    take_additional(has_additional, mask, namespace_idx, identifier, rest)
  end

  defp take_additional(0, mask, namespace_idx, identifier, rest) do
    {
      %__MODULE__{
        encoding_mask: mask,
        namespace_idx: namespace_idx,
        identifier: identifier
      },
      rest
    }
  end

  defp take_additional(4, mask, namespace_idx, identifier, <<server_idx::uint(32), rest::binary>>) do
    {
      %__MODULE__{
        encoding_mask: mask,
        namespace_idx: namespace_idx,
        identifier: identifier,
        server_idx: server_idx
      },
      rest
    }
  end

  defp take_additional(
         8,
         mask,
         namespace_idx,
         identifier,
         <<deserialize_string(server_uri), rest::binary>>
       ) do
    {
      %__MODULE__{
        encoding_mask: mask,
        namespace_idx: namespace_idx,
        identifier: identifier,
        server_uri: server_uri
      },
      rest
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

  def serialize(node_id) when is_binary(node_id) do
    node_id
    |> parse()
    |> serialize()
  end

  def serialize(_) do
    opc_null_value()
  end

  @spec to_string(%__MODULE__{}) :: String.t()
  def to_string(
        %__MODULE__{
          encoding_mask: 0,
          namespace_idx: _namespace_idx,
          identifier: identifier
        } = n_id
      ) do
    ("i=" <> Integer.to_string(identifier))
    |> has_additional_to_string(n_id)
  end

  def to_string(
        %__MODULE__{
          encoding_mask: mask,
          namespace_idx: namespace_idx,
          identifier: identifier
        } = n_id
      )
      when mask in [1, 2] do
    ("ns=" <> Integer.to_string(namespace_idx) <> ";i=" <> Integer.to_string(identifier))
    |> has_additional_to_string(n_id)
  end

  def to_string(
        %__MODULE__{
          encoding_mask: mask,
          namespace_idx: namespace_idx,
          identifier: identifier
        } = n_id
      )
      when mask in [3, 5] do
    ("ns=" <> Integer.to_string(namespace_idx) <> ";i=" <> identifier)
    |> has_additional_to_string(n_id)
  end

  defp has_additional_to_string(curr_string, %__MODULE__{server_uri: nil}) do
    curr_string
  end

  # defp has_additional_to_string(curr_string, %__MODULE__{
  #        server_idx: nil
  #        server_uri: uri
  #      }) do
  # end

  @spec parse(String.t()) :: %__MODULE__{}
  def parse(string) when is_binary(string) do
    string |> String.split(";") |> Enum.reduce(%__MODULE__{}, &do_parse/2)
  end

  defp do_parse("ns=" <> namespace_idx, %__MODULE__{} = node_id) do
    {namespace_idx, _} = Integer.parse(namespace_idx)
    Map.put(node_id, :namespace_idx, namespace_idx)
  end

  defp do_parse("i=" <> integer_identifier, %__MODULE__{} = node_id) do
    {identifier, _} = Integer.parse(integer_identifier)

    node_id
    |> Map.put(:encoding_mask, 2)
    |> Map.put(:identifier, identifier)
  end

  defp do_parse("s=" <> string_identifier, %__MODULE__{} = node_id) do
    node_id
    |> Map.put(:encoding_mask, 3)
    |> Map.put(:identifier, string_identifier)
  end

  defp do_parse("g=" <> _guid_identifier, %__MODULE__{} = _node_id) do
    # TODO: Guids are 16 bytes, but currently there is no conversion from string representation
    raise "Guid String Parsing not yet implemented"
  end
end
