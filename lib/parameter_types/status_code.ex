defmodule ExOpcua.ParameterTypes.StatusCode do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  defstruct [:severity, :sub_code, :structure_changed, :semantics_changed]

  @type t :: %__MODULE__{
          severity: atom(),
          sub_code: integer(),
          structure_changed: boolean(),
          semantics_changed: boolean()
        }

  @spec take(binary()) :: {%__MODULE__{}, binary()} | {nil, binary()}
  @severity [:good, :uncertain, :failure]

  def take(<<status_code::uint(32), rest::binary()>>) do
    status = decode(status_code)
    {status, rest}
  end

  def decode(code) when is_number(code), do: decode(<<code::unsigned-integer-32>>)

  def decode(
        <<sev::int(2), _reserved::binary-size(2)-unit(1), sub_code::int(12),
          struct_changed::int(1), sem_changed::int(1), _unused::binary-size(14)-unit(1)>>
      ) do
    %__MODULE__{
      severity: Enum.at(@severity, sev),
      sub_code: sub_code,
      structure_changed: struct_changed == 1,
      semantics_changed: sem_changed == 1
    }
  end
end
