defmodule ExOpcua.Services.Read do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.{Array, BuiltInDataTypes, NodeId}
  alias ExOpcua.ParameterTypes.{DataValue, ReadValueId}

  # @attribute_ids []

  def decode_response(bin_response) when is_binary(bin_response) do
    {read_results, _} = Array.take(bin_response, &DataValue.take/1)

    {
      :ok,
      %{
        read_results: read_results
      }
    }
  end

  def encode_read_all(%NodeId{} = node_id, %{
        sec_channel_id: sec_channel_id,
        token_id: token_id,
        auth_token: auth_token,
        seq_number: seq_number
      }) do
    read_values =
      1..27
      |> Enum.map(fn attr_id ->
        %ReadValueId{
          node_id: node_id,
          attribute_id: attr_id
        }
      end)

    <<
      sec_channel_id::int(32),
      token_id::int(32),
      seq_number::int(32),
      seq_number::int(32),
      0x01,
      0x00,
      631::int(16),
      # request_header
      NodeId.serialize(auth_token)::binary,
      # timestamp
      BuiltInDataTypes.Timestamp.from_datetime(DateTime.utc_now())::int(64),
      # request handle and diagnostics
      0::int(64),
      # audit entry id
      opc_null_value(),
      # timeout hint
      30000::int(32),
      # additional header
      0x00,
      0x00,
      0x00,
      # max age
      0::int(64),
      # timestamps to return (none)
      0::int(32),
      Array.serialize(read_values, &ReadValueId.serialize/1)::binary
    >>
    |> Protocol.append_message_header()
  end

  def encode_read_values(node_ids, %{
        sec_channel_id: sec_channel_id,
        token_id: token_id,
        auth_token: auth_token,
        seq_number: seq_number
      })
      when is_list(node_ids) do
    read_values =
      node_ids
      |> Enum.flat_map(fn node_id ->
        [
          # browse_name
          %ReadValueId{
            node_id: node_id,
            attribute_id: 3
          },
          # value
          %ReadValueId{
            node_id: node_id,
            attribute_id: 13
          }
        ]
      end)

    <<
      sec_channel_id::int(32),
      token_id::int(32),
      seq_number::int(32),
      seq_number::int(32),
      0x01,
      0x00,
      631::int(16),
      # request_header
      NodeId.serialize(auth_token)::binary,
      # timestamp
      BuiltInDataTypes.Timestamp.from_datetime(DateTime.utc_now())::int(64),
      # request handle and diagnostics
      0::int(64),
      # audit entry id
      opc_null_value(),
      # timeout hint
      30000::int(32),
      # additional header
      0x00,
      0x00,
      0x00,
      # max age
      0::int(64),
      # timestamps to return (none)
      0::int(32),
      Array.serialize(read_values, &ReadValueId.serialize/1)::binary
    >>
    |> Protocol.append_message_header()
  end

  def format_output(%{read_results: results}, node_ids, :pretty) do
    formatted =
      results
      |> Enum.chunk_every(2)
      |> Enum.map(&pair_to_kv/1)

    node_ids
    |> Enum.map(&NodeId.to_string/1)
    |> Enum.zip(formatted)
    |> Enum.into(%{})
  end

  def format_output(results, _node_ids, :raw), do: results

  defp pair_to_kv([%{value: nil}, _]), do: {}

  defp pair_to_kv([%{value: key}, %{value: value}]) do
    key = Map.get(key, :name)
    %{key => value}
  end
end
