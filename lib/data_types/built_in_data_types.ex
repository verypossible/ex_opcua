defmodule ExOpcua.DataTypes.BuiltInDataTypes do
  defmodule Macros do
    @moduledoc """
      Useful Macros for pattern matching binary responses or encoding replies
    """

    # Numeric Data Types.
    # Usage:
    #  <<255::uint(32)>>
    defmacro int(size), do: quote(do: little - integer - size(unquote(size)))
    defmacro uint(size), do: quote(do: little - unsigned - integer - size(unquote(size)))
    defmacro lfloat, do: quote(do: little - signed - float - 32)
    defmacro ldouble, do: quote(do: little - signed - float - 64)

    @doc """
      Used to patternmatch on strings in a response payload.
      var_name is the name of the variable that will be populated with this data

      NOTE: These do not handle the case where a value may be absent or NULL. Ensure
        that message REQUIRES this field to be present and non-null before using these
    """
    defmacro deserialize_string(var_name) do
      quote do
        <<size::int(32), unquote(var_name)::bytes-size(size)>>
      end
    end

    defmacro serialize_string(string) do
      quote do
        <<byte_size(unquote(string))::int(32), unquote(string)::binary>>
      end
    end

    defmacro deserialize_timestamp(var) do
      quote do
        <<unquote(var)::int(64)>>
      end
    end

    defmacro opc_null_value() do
      quote do
        <<0xFF, 0xFF, 0xFF, 0xFF>>
      end
    end
  end

  defmodule OpcBoolean do
    @doc """
      Recieves a binary that begins with a boolean
      Returns a native boolean and remaining binary.
        ex:
            iex(1) > ExOpcua.DataTypes.BuiltInDataTypes.OpcBoolean.take(bin)
            iex(2) > {false, <<>>}
    """
    @spec take(binary()) :: {boolean(), binary()} | {nil, binary()}
    def take(<<0x01, rest::binary>>), do: {true, rest}
    def take(<<0x00, rest::binary>>), do: {false, rest}
    def take(other_bin), do: {nil, other_bin}

    @doc """
      Takes a native boolean and returns the OPCUA Binary representation
    """
    def serialize(true), do: <<0x01>>
    def serialize(false), do: <<0x00>>
  end

  defmodule OpcString do
    import Macros

    @doc """
      Recieves a binary that begins with a string
      Returns the string and remaining binary.
        ex:
            iex(1) > ExOpcua.DataTypes.BuiltInDataTypes.OpcString.take(bin)
            iex(2) > {"hello", <<>>}
    """
    @spec take(binary()) :: {String.t(), binary()} | {nil, binary()}
    def take(<<opc_null_value(), rest::binary>>), do: {nil, rest}
    def take(<<deserialize_string(string), rest::binary>>), do: {string, rest}
    def take(other_bin), do: {nil, other_bin}

    @doc """
      Takes a string and returns the OPCUA Binary representation
    """
    def serialize(nil), do: opc_null_value()
    def serialize(string), do: serialize_string(string)
  end

  defmodule Timestamp do
    import Macros

    @doc """
      Recieves a binary that begins with a timestamp
      Returns a DateTime and remaining binary.
        ex:
            iex(1) > BuiltInDataTypes.Timestamp.take(bin)
            iex(2) > {%DateTime{}, <<>>}
    """
    @spec take(binary()) :: {String.t(), binary()} | {nil, binary()}
    def take(<<deserialize_timestamp(timestamp), rest::binary>>) do
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

  defmodule LocalizedText do
    import Macros

    @doc """
      Recieves a binary that begins with a localized text
      Returns a string and remaining binary.
        ex:
            iex(1) > BuiltInDataTypes.LocalizedText.take(bin)
            iex(2) > {String(), <<>>}

      0x01 - locale info only
      0x02 - string info only
      0x03 - local and string info
    """
    @spec take(binary()) :: {String.t(), binary()} | {nil, binary()}
    def take(<<0x01, deserialize_string(locale), rest::binary>>), do: {"", rest}
    def take(<<0x02, deserialize_string(string), rest::binary>>), do: {string, rest}

    def take(<<0x03, deserialize_string(locale), deserialize_string(string), rest::binary>>) do
      {string, rest}
    end

    def take(other_binary), do: {nil, other_binary}

    @doc """
      Takes a string and locale string
      Returns the OPCUA Binary representation of Localized Text
    """
    @spec serialize(String.t(), String.t() | nil) :: binary()
    def serialize(string, locale \\ nil)

    def serialize(string, nil) do
      <<0x02, serialize_string(string)>>
    end

    def serialize(string, locale) do
      <<0x03, serialize_string(locale), serialize_string(string)>>
    end
  end
end
