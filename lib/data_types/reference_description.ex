defmodule ExOpcua.DataTypes.ReferenceDescription do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{NodeId, QualifiedName}
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

  @node_classes %{
    1 => :object,
    2 => :variable,
    4 => :method,
    8 => :object_type,
    16 => :variable_type,
    32 => :reference_type,
    64 => :data_type,
    128 => :view
  }

  @doc """
    Takes in a binary beginning with a Reference Type
    Returns a tuple of the Reference Type Struct and remaining binary
  """
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {:error, binary()}
  def take(binary) do
    with {ref_type_id, rest} <- NodeId.take(binary),
         {is_forward, rest} <- OpcBoolean.take(rest),
         {node_id, rest} <- NodeId.take(rest),
         {browse_name, rest} <- QualifiedName.take(rest),
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

  defp take_node_class(<<class::uint(32), rest::binary>>) do
    {Map.get(@node_classes, class, :unspecified), rest}
  end
end
