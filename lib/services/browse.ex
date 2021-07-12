defmodule ExOpcua.Services.Browse do
  alias ExOpcua.DataTypes.Array
  alias ExOpcua.ParameterTypes.BrowseResult
  alias ExOpcua.Protocol

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
