defmodule ExOpcua.DataTypes.BuiltInDataTypes do
  defmodule Macros do
    defmacro deserialize_string(var_name) do
      quote do
        <<size::little-integer-size(32), unquote(var_name)::bytes-size(size)>>
      end
    end

    defmacro serialize_string(string) do
      quote do
        <<byte_size(unquote(string))::little-integer-size(32), unquote(string)::binary>>
      end
    end

    defmacro deserialize_timestamp(var) do
      quote do
        <<unquote(var)::little-integer-size(64)>>
      end
    end

    defmacro opc_null_value() do
      quote do
        <<0xFF, 0xFF, 0xFF, 0xFF>>
      end
    end
  end

  defmodule OpcString do
    require Macros

    @doc """
      Recieves a binary that begins with a string
      Returns the string and remaining binary.
        ex:
            iex(1) > ExOpcua.DataTypes.BuiltInDataTypes.OpcString.take(bin)
            iex(2) > {"hello", <<>>}
    """
    @spec take(binary()) :: {String.t(), binary()} | {nil, binary()}
    def take(<<Macros.deserialize_string(string), rest::binary>>) do
      {string, rest}
    end

    def take(other_bin) do
      {nil, other_bin}
    end
  end

  defmodule Timestamp do
    require Macros

    @doc """
      Recieves a binary that begins with a timestamp
      Returns a DateTime and remaining binary.
        ex:
            iex(1) > BuiltInDataTypes.Timestamp.take(bin)
            iex(2) > {%DateTime{}, <<>>}
    """
    @spec take(binary()) :: {String.t(), binary()} | {nil, binary()}
    def take(<<Macros.deserialize_timestamp(timestamp), rest::binary>>) do
      {to_datetime(timestamp), rest}
    end

    def take(other_binary) do
      {nil, other_binary}
    end

    @doc """
      From OPCUA Spec:
      A DateTime value shall be encoded as a 64-bit signed integer
      which represents the number of 100 nanosecond intervals since
      January 1, 1601 (UTC).
    """
    @spec to_datetime(number()) :: DateTime.t()
    def to_datetime(nanoseconds) do
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
    def from_datetime(%DateTime{} = datetime) do
      floor(
        DateTime.diff(
          datetime,
          DateTime.from_naive!(~N[1601-01-01 00:00:00.000], "Etc/UTC"),
          :nanosecond
        ) / 100
      )
    end
  end
end
