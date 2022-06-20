defmodule ExOpcua.DataTypes.BrowseDescription do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.NodeId
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcBoolean

  defstruct [
    :node_id,
    :browse_direction,
    :reference_type_id,
    :include_subtypes,
    :node_class_mask,
    :result_mask
  ]

  @browse_direction [:forward, :inverse, :both, :invalid]

  @type t :: %__MODULE__{
          node_id: NodeId.t(),
          browse_direction: atom(),
          reference_type_id: NodeId.t(),
          include_subtypes: boolean(),
          node_class_mask: integer(),
          result_mask: integer()
        }

  def serialize(%__MODULE__{
        node_id: node_id,
        browse_direction: b_dir,
        reference_type_id: ref_type,
        include_subtypes: inc_subtypes,
        node_class_mask: node_class,
        result_mask: result_mask
      }) do
    <<
      NodeId.serialize(node_id)::binary,
      Enum.find_index(@browse_direction, &match?(b_dir, &1))::int(32),
      NodeId.serialize(ref_type)::binary,
      OpcBoolean.serialize(inc_subtypes)::binary,
      node_class::uint(32),
      result_mask::uint(32)
    >>
  end
end

# %ExOpcua.DataTypes.BrowseDescription{
#   node_id: %{encoding_mask: 3, namespace_idx: 3, identifier: "85/0:Simulation"},
#   browse_direction: :forward,
#   reference_type_id: %{encoding_mask: 0, identifier: 31},
#   include_subtypes: true,
#   node_class_mask: 0,
#   result_mask: 0
# }
