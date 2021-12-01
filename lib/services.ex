defmodule ExOpcua.Services do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes

  alias ExOpcua.Services.{
    ActivateSession,
    Browse,
    CreateSession,
    GetEndpoints,
    OpenSecureChannel,
    Read
  }

  alias ExOpcua.ParameterTypes.StatusCode

  @service_ids %{
    431 => GetEndpoints,
    449 => OpenSecureChannel,
    464 => CreateSession,
    470 => ActivateSession,
    530 => Browse,
    634 => Read
  }

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
          type::int(16),
          deserialize_timestamp(timestamp),
          _req_handle::int(32),
          status_code::uint(32),
          _diagnostic_mask::bytes-size(1),
          _string_table_size::int(32),
          _additional_header::bytes-size(3),
          rest::binary
        >>,
        nil,
        %{}
      ) do
    status_code = StatusCode.decode(status_code)

    decode(rest, type, %{
      service_status: status_code,
      timestamp: BuiltInDataTypes.Timestamp.to_datetime(timestamp)
    })
  end

  def decode(payload, service_index, decoded_map) when is_map_key(@service_ids, service_index) do
    {:ok, response} = Map.get(@service_ids, service_index).decode_response(payload)
    {:ok, Map.merge(decoded_map, response)}
  end

  def decode(_any, service_index, _decoded_map) do
    {:error, "service not implemented #{inspect(service_index)}"}
  end
end
