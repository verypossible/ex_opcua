defmodule ExOpcua.ParameterTypes.ReadValueId do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{NodeId, QualifiedName}
  defstruct [:node_id, :attribute_id, :index_range, :data_encoding]

  @type t :: %__MODULE__{
          node_id: NodeId.t(),
          attribute_id: integer(),
          # index_range: NumericRange.t(), # TODO
          data_encoding: QualifiedName.t()
        }

  def serialize(%__MODULE__{
        node_id: nodeId,
        attribute_id: attr_id,
        index_range: _range,
        data_encoding: _
      }) do
    <<
      NodeId.serialize(nodeId)::binary,
      attr_id::uint(32),
      opc_null_value(),
      QualifiedName.serialize(nil)::binary
    >>
  end
end
