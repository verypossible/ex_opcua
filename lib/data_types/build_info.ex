defmodule ExOpcua.DataTypes.BuildInfo do
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

  def take(binary) do
    Enum.reduce(
      [
        :product_uri,
        :manufacturer_name,
        :product_name,
        :software_version,
        :build_number,
        :build_date
      ],
      {%{}, binary},
      fn kind, {acc_map, rest} ->
        {value, rest} = OpcString.take(rest)
        {Map.put(acc_map, kind, value), rest}
      end
    )
  end
end
