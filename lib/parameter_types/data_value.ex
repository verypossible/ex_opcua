defmodule ExOpcua.ParameterTypes.DataValue do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.ParameterTypes.StatusCode
  alias ExOpcua.DataTypes
  alias ExOpcua.DataTypes.BuiltInDataTypes.Timestamp

  defstruct [
    :value,
    :status_code,
    :source_timestamp,
    :source_picoseconds,
    :server_timestamp,
    :server_picoseconds
  ]

  @type t :: %__MODULE__{
          value: any(),
          status_code: StatusCode.t(),
          source_timestamp: DateTime.t(),
          source_picoseconds: integer(),
          server_timestamp: DateTime.t(),
          server_picoseconds: integer()
        }
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {nil, binary()}
  def take(<<
        _::binary-size(1)-unit(1),
        _::binary-size(1)-unit(1),
        has_server_picoseconds::integer-native-size(1),
        has_source_picoseconds::integer-native-size(1),
        has_server_timestamp::integer-native-size(1),
        has_source_timestamp::integer-native-size(1),
        has_status_code::integer-native-size(1),
        has_value::integer-native-size(1),
        rest::binary
      >>) do
    {%__MODULE__{}, rest}
    |> parse_value(has_value)
    |> parse_status_code(has_status_code)
    |> parse_timestamp(has_source_timestamp, :source_timestamp)
    |> parse_timestamp(has_server_timestamp, :server_timestamp)
    |> parse_timestamp(has_source_picoseconds, :source_picoseconds)
    |> parse_timestamp(has_server_picoseconds, :server_picoseconds)
  end

  defp parse_value({acc, <<rest::binary>>}, 1) do
    {value, rest} = DataTypes.take_data_type(rest)
    {Map.put(acc, :value, value), rest}
  end

  defp parse_value({acc, rest}, 0) do
    {acc, rest}
  end

  defp parse_status_code({acc, rest}, 1) do
    {status_code, rest} = StatusCode.take(rest)
    {Map.put(acc, :status_code, status_code.severity), rest}
  end

  defp parse_status_code({acc, rest}, 0), do: {acc, rest}

  defp parse_timestamp({acc, <<ts::int(64), rest::binary>>}, 1, key) do
    timestamp = Timestamp.to_datetime(ts)
    {Map.put(acc, key, timestamp), rest}
  end

  defp parse_timestamp({acc, rest}, 0, _key), do: {acc, rest}
end
