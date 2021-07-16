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
    with {node, <<1, rest::binary>>} <- NodeId.take(bin) do
      <<size::int(32), data::binary-size(size), rest::binary>> = rest
      data_type = Map.get(@data_types, node.identifier, :not_implemented)

      value =
        if data_type != :not_implemented do
          {value, _} = data_type.take(data)
          value
        else
          :not_implemented
        end

      {value, rest}
    end
  end
end
