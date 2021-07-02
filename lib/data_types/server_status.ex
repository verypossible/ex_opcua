defmodule ExOpcua.DataTypes.ServerStatus do
  alias ExOpcua.DataTypes.BuiltInDataTypes.{
    Timestamp,
    LocalizedText
  }

  alias ExOpcua.DataTypes.BuildInfo

  import ExOpcua.DataTypes.BuiltInDataTypes.Macros

  def take(binary) do
    {%{}, binary}
    |> parse_timestamp(:start_time)
    |> parse_timestamp(:current_time)
    |> parse_server_state()
    |> parse_build_info()
    |> parse_seconds_till_shutdown()
    |> parse_shutdown_reason()
  end

  def parse_timestamp({acc, <<ts::int(64), rest::binary>>}, key) do
    timestamp = Timestamp.to_datetime(ts)
    {Map.put(acc, key, timestamp), rest}
  end

  def parse_server_state({acc, <<state::int(32), rest::binary>>}) do
    {Map.put(acc, :server_state, state), rest}
  end

  def parse_build_info({acc, rest}) do
    {value, rest} = BuildInfo.take(rest)
    {Map.put(acc, :build_info, value), rest}
  end

  def parse_seconds_till_shutdown({acc, <<value::int(32), rest::binary>>}) do
    {Map.put(acc, :seconds_till_shutdown, value), rest}
  end

  def parse_shutdown_reason({acc, rest}) do
    {value, rest} = LocalizedText.take(rest)
    {Map.put(acc, :shutdown_reason, value), rest}
  end
end
