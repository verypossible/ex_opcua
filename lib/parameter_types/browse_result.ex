defmodule ExOpcua.ParameterTypes.BrowseResult do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString
  alias ExOpcua.DataTypes.Array
  alias ExOpcua.ParameterTypes.{ReferenceDescription, StatusCode}

  defstruct [
    :status_code,
    :continue_point,
    :references
  ]

  @type t :: %__MODULE__{
          status_code: binary(),
          continue_point: binary(),
          references: [ReferenceDescription.t()]
        }

  @doc """
  	Takes in a binary beginning with a Browse Result
  	Returns a tuple of the BrowseResult and remaining binary
  """
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {:error, binary()}
  def take(binary) do
    with {status_code, rest} <- StatusCode.take(binary),
         {continue_point, rest} <- OpcString.take(rest),
         {references, _rest} <- Array.take(rest, &ReferenceDescription.take/1) do
      {
        %__MODULE__{
          status_code: status_code,
          continue_point: continue_point,
          references: references
        },
        rest
      }
    end
  end

  defp take_status_code(<<code::uint(32), rest::binary>>) do
    {code, rest}
  end
end
