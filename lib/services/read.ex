defmodule ExOpcua.Services.Read do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{Array, BuiltInDataTypes, NodeId}
  alias ExOpcua.ParameterTypes.{DataValue, ReadValueId}

  @message_types [
    hello: "HEL",
    open_secure_channel: "OPN",
    close_secure_channel: "CLO",
    message: "MSG"
  ]
  @is_final [
    intermediate: "C",
    final: "F",
    final_aborted: "A"
  ]

  def decode_response(bin_response) when is_binary(bin_response) do
    {read_results, _} = Array.take(bin_response, &DataValue.take/1)

    {
      :ok,
      %{
        read_results: read_results
      }
    }
  end

  def encode_read_all(%NodeId{} = nodeId, %{
        sec_channel_id: sec_channel_id,
        token_id: token_id,
        auth_token: auth_token,
        seq_number: seq_number
      }) do
    next_sequence_num = seq_number + 1

    read_values =
      1..27
      |> Enum.map(fn attr_id ->
        %ReadValueId{
          node_id: nodeId,
          attribute_id: attr_id
        }
      end)

    payload = <<
      sec_channel_id::int(32),
      token_id::int(32),
      next_sequence_num::int(32),
      next_sequence_num::int(32),
      0x01,
      0x00,
      631::int(16),
      # request_header
      NodeId.serialize(auth_token)::binary,
      # timestamp
      BuiltInDataTypes.Timestamp.from_datetime(DateTime.utc_now())::int(64),
      # request handle and diagnostics
      0::int(64),
      # audit entry id
      opc_null_value(),
      # timeout hint
      30000::int(32),
      # additional header
      0x00,
      0x00,
      0x00,
      # max age
      0::int(64),
      # timestamps to return (none)
      0::int(32),
      Array.serialize(read_values, &ReadValueId.serialize/1)::binary
    >>

    msg_size = 8 + byte_size(payload)

    <<
      @message_types[:message]::binary,
      @is_final[:final]::binary,
      msg_size::int(32)
    >> <> payload
  end
end
