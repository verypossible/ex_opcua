defmodule ExOpcua.Services.Read do
  alias ExOpcua.DataTypes.Array
  alias ExOpcua.ParameterTypes.DataValue

  def decode_response(bin_response) when is_binary(bin_response) do
    with {read_results, _} <- Array.take(bin_response, &DataValue.take/1) do
      {
        :ok,
        %{
          read_results: read_results
        }
      }
    end
  end
end
