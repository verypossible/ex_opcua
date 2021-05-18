defmodule ExOpcua.Protocol.Services do
  def decode(<<>>) do
    {:ok, nil}
  end

  # OpenSecureChannelResponse binary(449)
  def decode(<<
        0x01,
        0x01,
        449::little-integer-size(16),
        _timestamp::bytes-size(8),
        _req_handle::little-integer-size(32),
        result::little-integer-size(32),
        _diagnostic_mask::bytes-size(1),
        _string_table_size::little-integer-size(32),
        _additional_header::bytes-size(3),
        _server_proto_ver::little-integer-size(32),
        sec_token::bytes-size(20),
        _nonce::binary
      >>) do
    {:ok, %{result: result, sec_token: sec_token}}
  end

  def decode(any) do
    {:ok, %{not_implemented: any}}
  end
end
