defmodule ExOpcua.DataTypes.ExtensionObject do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Extension Object
    https://reference.opcfoundation.org/v104/Core/docs/Part6/5.1.5/
  """
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString
  alias ExOpcua.DataTypes.{NodeId, ServerStatus}

  @data_types %{
    864 => ServerStatus
  }
  def take(<<opc_null_value(), rest::binary>>) do
    {nil, rest}
  end

  def take(bin) do
    bin
    |> NodeId.take()
    |> take_body()
  end

  # no body info present
  defp take_body({_node_id, <<0, rest::binary>>}), do: {nil, rest}

  defp take_body({node_id, <<1, size::int(32), data::binary-size(size), rest::binary>>}) do
    value =
      case Map.fetch(@data_types, node_id.identifier) do
        {:ok, data_type} ->
          {value, _} = data_type.take(data)
          value

        :error ->
          "Data Type Not Implemented"
      end

    {value, rest}
  end

  # XML Body is not parsed, returned as a string to user
  defp take_body({_node_id, <<2, rest::binary>>}) do
    OpcString.take(rest)
  end
end
