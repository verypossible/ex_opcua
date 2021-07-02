defmodule ExOpcua.ParameterTypes.ReadValueId do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  import ExOpcua.DataTypes.{NodeId, NumericRange, QualifiedName}
  defstruct [:node_id, :attribute_id, :index_range, :data_encoding]

  @type t :: %__MODULE__{
          node_id: NodeId.t(),
          attribute_id: integer(),
          index_range: NumericRange.t(),
          data_encoding: QualifiedName.t()
        }

  # @spec take(binary()) :: {%__MODULE__{}, binary()} | {nil, binary()}
  # @severity [:good, :uncertain, :failure]

  # def take(<<status_code::uint(32), rest::binary()>>) do
  #   status = decode(status_code)
  #   {status, rest}
  # end

  # def decode(code) when is_number(code), do: decode(<<code::unsigned-integer-32>>)

  # def decode(
  #       <<sev::int(2), _reserved::binary-size(2)-unit(1), sub_code::int(12),
  #         struct_changed::int(1), sem_changed::int(1), _unused::binary-size(14)-unit(1)>>
  #     ) do
  #   %__MODULE__{
  #     severity: Enum.at(@severity, sev),
  #     sub_code: sub_code,
  #     structure_changed: struct_changed == 1,
  #     semantics_changed: sem_changed == 1
  #   }
  # end
end
