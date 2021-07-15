defmodule ExOpcua.DataTypes.ExtensionObject do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Extension Object
    https://reference.opcfoundation.org/v104/Core/docs/Part6/5.1.5/
  """
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{NodeId, ServerStatus}

  @data_types %{
    864 => ServerStatus
  }
  def take(<<opc_null_value(), rest::binary>>) do
    {nil, rest}
  end

  def take(bin) do
    with {node, <<encoding_mask, rest::binary>>} <- NodeId.take(bin) do
      <<size::int(32), data::binary-size(size), rest::binary>> = rest

      value =
        case encoding_mask do
          0 ->
            :not_implemented

          1 ->
            case Map.get(@data_types, node.identifier) do
              nil ->
                :not_implemented

              data_type ->
                {value, _} = data_type.take(data)
                value
            end
        end

      {value, rest}
    end
  end
end
