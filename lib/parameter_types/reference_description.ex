defmodule ExOpcua.ParameterTypes.ReferenceDescription do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{NodeId}
  alias ExOpcua.DataTypes.BuiltInDataTypes.{OpcBoolean, LocalizedText}

  defstruct [
    :reference_type_id,
    :is_forward,
    :node_id,
    :browse_name,
    :display_name,
    :node_class,
    :type_definition
  ]

  @type t :: %__MODULE__{
          reference_type_id: NodeId.t(),
          is_forward: boolean(),
          node_id: NodeId.t(),
          browse_name: any(),
          display_name: String.t(),
          node_class: atom(),
          type_definition: NodeId.t()
        }

  @node_classes [
    :object,
    :variable,
    :method,
    :object_type,
    :variable_type,
    :reference_type,
    :data_type,
    :view
  ]

  @doc """
    Takes in a binary beginning with a Reference Type
    Returns a tuple of the Reference Type Struct and remaining binary
  """
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {:error, binary()}
  def take(binary) do
    with {ref_type_id, rest} <- NodeId.take(binary),
         {is_forward, rest} <- OpcBoolean.take(rest),
         {node_id, rest} <- NodeId.take(rest),
         {browse_name, rest} <- take_qualified_name(rest),
         {display_name, rest} <- LocalizedText.take(rest),
         {node_class, rest} <- take_node_class(rest),
         {type_definition, rest} <- NodeId.take(rest) do
      {
        %__MODULE__{
          reference_type_id: ref_type_id,
          is_forward: is_forward,
          node_id: node_id,
          browse_name: browse_name,
          display_name: display_name,
          node_class: node_class,
          type_definition: type_definition
        },
        rest
      }
    end
  end

  defp take_qualified_name(<<opc_null_value(), rest::binary>>) do
    {nil, rest}
  end

  defp take_qualified_name(<<id::int(16), deserialize_string(name), rest::binary>>) do
    {%{id: id, name: name}, rest}
  end

  defp take_node_class(<<0::uint(32), rest::binary>>), do: {:object, rest}

  defp take_node_class(<<class::uint(32), rest::binary>>) do
    class =
      class
      |> :math.log2()
      |> round()

    {Enum.at(@node_classes, class), rest}
  end
end
