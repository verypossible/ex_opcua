defmodule ExOpcua.Services.CreateSession do
  require ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{BuiltInDataTypes, NodeIds}

  def decode_response(bin_response) when is_binary(bin_response) do
    {%NodeIds.NodeId{} = session_id, bin_response} = NodeIds.take(bin_response)
    {%NodeIds.NodeId{} = auth_token, bin_response} = NodeIds.take(bin_response)

    decoded_map =
      bin_response
      |> decode_rest()
      |> Map.merge(%{
        session_id: session_id.raw_binary,
        auth_token: auth_token.raw_binary
      })

    {:ok, decoded_map}
  end

  defp decode_rest(<<
         revised_session_timeout::little-float-size(64),
         BuiltInDataTypes.Macros.deserialize_string(_server_nonce),
         BuiltInDataTypes.Macros.deserialize_string(server_cert),
         _endpoints_array_size::little-integer-size(32),
         rest::binary
       >>) do
    %{
      server_cert: server_cert,
      revised_session_timeout: round(revised_session_timeout),
      session_expire_time:
        DateTime.add(DateTime.utc_now(), round(revised_session_timeout), :millisecond),
      rest: rest
    }
  end
end
