defmodule ExOpcua.Services do
  require ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes
  alias ExOpcua.Services.{OpenSecureChannel, CreateSession, ActivateSession}

  @spec decode(binary()) ::
          {:ok, any()}
          | {:not_implemented, any()}
          | {:error, any()}
  def decode(payload \\ <<>>, type \\ nil, decoded_map \\ %{})

  def decode(payload, _, _) when not is_binary(payload), do: {:error, :bad_service_payload}

  def decode(<<>>, _, decoded_map) do
    {:ok, decoded_map}
  end

  # response header (arrives with every message)
  def decode(
        <<
          _::bytes-size(2),
          type::little-integer-size(16),
          BuiltInDataTypes.Macros.deserialize_timestamp(timestamp),
          _req_handle::little-integer-size(32),
          0::little-integer-size(32),
          _diagnostic_mask::bytes-size(1),
          _string_table_size::little-integer-size(32),
          _additional_header::bytes-size(3),
          rest::binary
        >>,
        nil,
        %{}
      ) do
    decode(rest, type, %{timestamp: BuiltInDataTypes.Timestamp.to_datetime(timestamp)})
  end

  # OpenSecureChannelResponse binary(449)
  def decode(payload, 449, decoded_map) do
    {:ok, response_map} = OpenSecureChannel.decode_response(payload)
    {:ok, Map.merge(decoded_map, response_map)}
  end

  # CreateSessionResponse binary(464)
  def decode(payload, 464, decoded_map) do
    {:ok, response_map} = CreateSession.decode_response(payload)
    {:ok, Map.merge(decoded_map, response_map)}
  end

  # ActivateSessionResponse binary(470)
  def decode(payload, 470, _decoded_map) do
    :ok = ActivateSession.decode_response(payload)
    {:ok, :activated}
  end

  def decode(_any, type, _decoded_map) do
    {:not_implemented, type}
  end
end
