defmodule ExOpcua.Protocol.Services do
  alias ExOpcua.Protocol.DataTypes

  @spec decode(binary()) ::
          {:ok, any()}
          | {:error, any()}
  def(decode(<<>>)) do
    {:ok, nil}
  end

  # OpenSecureChannelResponse binary(449)
  def decode(<<
        _::bytes-size(1),
        _::bytes-size(1),
        449::little-integer-size(16),
        timestamp::little-integer-size(64),
        _req_handle::little-integer-size(32),
        0::little-integer-size(32),
        _diagnostic_mask::bytes-size(1),
        _string_table_size::little-integer-size(32),
        _additional_header::bytes-size(3),
        _server_proto_ver::little-integer-size(32),
        sec_channel_id::little-integer-size(32),
        token_id::little-integer-size(32),
        token_created_at::little-integer-size(64),
        revised_lifetime_in_ms::little-integer-size(32),
        _nonce::binary
      >>) do
    {:ok,
     %{
       sec_channel_id: sec_channel_id,
       token_id: token_id,
       timestamp: DataTypes.timestamp_to_datetime(timestamp),
       token_created_at: DataTypes.timestamp_to_datetime(token_created_at),
       revised_lifetime_in_ms: revised_lifetime_in_ms,
       token_expire_time: DateTime.add(DateTime.utc_now(), revised_lifetime_in_ms, :millisecond)
     }}
  end

  # OpenSessionResponse binary(464)
  def decode(<<
        _::bytes-size(1),
        _::bytes-size(1),
        464::little-integer-size(16),
        timestamp::little-integer-size(64),
        _req_handle::little-integer-size(32),
        0::little-integer-size(32),
        _diagnostic_mask::bytes-size(1),
        _string_table_size::little-integer-size(32),
        _additional_header::bytes-size(3),
        session_id::bytes-size(7),
        auth_token::bytes-size(7),
        revised_session_timeout::little-float-size(64),
        server_nonce_size::little-integer-size(32),
        _server_nonce::bytes-size(server_nonce_size),
        server_cert_size::little-integer-size(32),
        server_cert::bytes-size(server_cert_size),
        _endpoints_array_size::little-integer-size(32),
        rest::binary
      >>) do
    {:ok,
     %{
       session_id: session_id,
       auth_token: auth_token,
       timestamp: DataTypes.timestamp_to_datetime(timestamp),
       server_cert: server_cert,
       revised_session_timeout: round(revised_session_timeout),
       session_expire_time:
         DateTime.add(DateTime.utc_now(), round(revised_session_timeout), :millisecond),
       rest: rest
     }}
  end

  def decode(any) do
    {:error, %{not_implemented: Base.encode16(any)}}
  end
end
