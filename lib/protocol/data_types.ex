defmodule ExOpcua.Protocol.DataTypes do
  @doc """
  	From OPCUA Spec:
   	A DateTime value shall be encoded as a 64-bit signed integer
   	which represents the number of 100 nanosecond intervals since
   	January 1, 1601 (UTC).
  """
  def timestamp_to_datetime(nanoseconds) do
    DateTime.add(
      DateTime.from_naive!(~N[1601-01-01 00:00:00.000], "Etc/UTC"),
      floor(nanoseconds * 100),
      :nanosecond
    )
  end

  @doc """
  	From OPCUA Spec:
   	A DateTime value shall be encoded as a 64-bit signed integer
   	which represents the number of 100 nanosecond intervals since
   	January 1, 1601 (UTC).
  """
  def datetime_to_timestamp(%DateTime{} = datetime) do
    floor(
      DateTime.diff(
        datetime,
        DateTime.from_naive!(~N[1601-01-01 00:00:00.000], "Etc/UTC"),
        :nanosecond
      ) / 100
    )
  end
end
