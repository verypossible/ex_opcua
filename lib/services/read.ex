defmodule ExOpcua.Services.Read do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.Protocol
  alias ExOpcua.DataTypes.{Array, BuiltInDataTypes, NodeId}
  alias ExOpcua.ParameterTypes.{DataValue, ReadValueId}

  @attribute_ids [
    :node_id,
    :node_class,
    :browse_name,
    :display_name,
    :description,
    :write_mask,
    :user_write_mask,
    :is_abstract,
    :symmetric,
    :inverse_name,
    :contains_no_loops,
    :event_notifier,
    :value,
    :data_type,
    :value_rank,
    :array_dimensions,
    :access_level,
    :user_access_level,
    :minimum_sampling_interval,
    :historizing,
    :executable,
    :user_executable,
    :data_type_definition,
    :role_permissions,
    :user_role_permissions,
    :access_retrictions,
    :access_level_ex
  ]

  def attribute_ids, do: @attribute_ids

  @spec decode_response(binary()) :: {:ok, map()}
  def decode_response(bin_response) when is_binary(bin_response) do
    {read_results, _} = Array.take(bin_response, &DataValue.take/1)

    {
      :ok,
      %{
        read_results: read_results
      }
    }
  end

  @spec encode_read_all(list(String.t()), pid()) :: map()
  def encode_read_all(
        node_ids,
        %{
          sec_channel_id: _sec_channel_id,
          token_id: _token_id,
          auth_token: _auth_token,
          seq_number: _seq_number
        } = s
      ) do
    encode_read_attrs(node_ids, @attribute_ids, s)
  end

  @spec encode_read_attrs(list(String.t()), list(Atom.t()), pid()) :: map()
  def encode_read_attrs(node_ids, attrs, %{
        sec_channel_id: sec_channel_id,
        token_id: token_id,
        auth_token: auth_token,
        seq_number: seq_number
      })
      when is_list(node_ids) do
    read_values =
      node_ids
      |> Enum.flat_map(fn node_id ->
        attrs
        |> Enum.map(fn attr ->
          %ReadValueId{
            node_id: node_id,
            attribute_id: Enum.find_index(@attribute_ids, &Kernel.===(&1, attr)) + 1
          }
        end)
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

  @spec format_output(map(), list(String.t()), list(Atom.t()), Atom.t()) :: map()
  def format_output(%{read_results: results}, node_ids, attrs, :pretty) do
    formatted =
      results
      |> Enum.chunk_every(length(attrs))
      |> Enum.map(fn r ->
        to_map(r, attrs)
      end)

    node_ids
    |> Enum.map(&NodeId.to_string/1)
    |> Enum.zip(formatted)
    |> Enum.into(%{})
  end

  @spec format_output(map(), list(String.t()), list(Atom.t()), Atom.t()) :: map()
  def format_output(results, _node_ids, _attrs, :raw), do: results

  defp to_map(results, attrs) do
    Enum.zip(attrs, results)
    |> Enum.map(&to_kv/1)
    |> Enum.flat_map(&Function.identity/1)
    |> Enum.into(%{})
  end

  defp to_kv({key, %DataValue{value: v}}) do
    %{key => get_value(v)}
  end

  defp get_value(val) when is_map(val), do: Map.get(val, :name)
  defp get_value(val) when is_struct(val), do: Map.from_struct(val)
  defp get_value(nil), do: nil
  defp get_value(val), do: val
end
