defmodule ExOpcua.Services.Browse do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.Array
  alias ExOpcua.ParameterTypes.BrowseResult

  def decode_response(bin_response) when is_binary(bin_response) do
    with {browse_results, _} <- Array.take(bin_response, &BrowseResult.take/1) do
      {
        :ok,
        %{
          browse_results: browse_results
        }
      }
    end
  end
end
