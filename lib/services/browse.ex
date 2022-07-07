defmodule ExOpcua.Services.Browse do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{Array, BrowseDescription, BrowseResult, NodeId}
  alias ExOpcua.DataTypes.BuiltInDataTypes.Timestamp

  def decode_response(bin_response) when is_binary(bin_response) do
    with {browse_results, _} <- Array.take(bin_response, &BrowseResult.take/1) do
      {
        :ok,
        %{
          browse_results: browse_results
        }
      }
    end
  end

  def encode_command(browse_list, %{auth_token: auth_token}) when is_list(browse_list) do
    <<
      0x01,
      0x00,
      527::int(16),
      # request_header
      NodeId.serialize(auth_token)::binary,
      # timestamp
      Timestamp.from_datetime(DateTime.utc_now())::int(64),
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
      # view description (empty)
      0x00::size(14)-unit(8),
      # max nodes to return (no limit)
      0x0::uint(32),
      Array.serialize(browse_list, &BrowseDescription.serialize/1)::binary
    >>
  end

  def encode_command(browse_attr, state), do: encode_command([browse_attr], state)
end
