defmodule ExOpcua.SecurityProfile.Encryption.Basic256Sha256 do
  use ExOpcua.SecurityProfile.Encryption

  @policy_uri "http://opcfoundation.org/UA/SecurityPolicy#Basic256Sha256"

  # TODO: This policy should support 512 signature size as well when larger RSA is used
  @signature_size_rsa2048 256
  @signature_size_sha256 32
  @rsa_encrypt_block_size 214
  @sym_encrypt_block_size 16

  def uri(), do: @policy_uri

  def asym_encrypt(data, key) do
    do_asym_encrypt(data, key, <<>>)
  end

  defp do_asym_encrypt(<<>>, _sp, acc), do: acc

  defp do_asym_encrypt(<<blob::binary-size(@rsa_encrypt_block_size), rest::binary>>, key, acc) do
    do_asym_encrypt(
      rest,
      key,
      acc <> :public_key.encrypt_public(blob, key, [{:rsa_pad, :rsa_pkcs1_oaep_padding}])
    )
  end

  def sym_encrypt(<<>>, _key, _iv), do: <<>>

  def sym_encrypt(data, key, iv) do
    :crypto.crypto_one_time(:aes_256_cbc, key, iv, data, true)
  end

  def asym_decrypt(data, key) do
    do_asym_decrypt(data, key, <<>>)
  end

  defp do_asym_decrypt(<<>>, _private_key, acc), do: acc

  defp do_asym_decrypt(<<blob::binary-size(256), rest::binary>>, key, acc) do
    do_asym_decrypt(
      rest,
      key,
      acc <> :public_key.decrypt_private(blob, key, [{:rsa_pad, :rsa_pkcs1_oaep_padding}])
    )
  end

  defp do_asym_decrypt(blob, _, _) do
    raise "Data Chunk not divisible by 256. Size #{inspect(byte_size(blob))}"
  end

  def sym_decrypt(blob, key, iv) do
    :crypto.crypto_one_time(:aes_256_cbc, key, iv, blob, false)
  end

  def derive_sym_keys(client_nonce, server_nonce) do
    <<client_signing_key::binary-size(32), client_encrypting_key::binary-size(32),
      client_iv::binary-size(16), _rest::binary>> = p_hash(server_nonce, client_nonce, 80)

    <<server_signing_key::binary-size(32), server_encrypting_key::binary-size(32),
      server_iv::binary-size(16), _rest::binary>> = p_hash(client_nonce, server_nonce, 80)

    %{
      c_sign_key: client_signing_key,
      c_enc_key: client_encrypting_key,
      c_init_vector: client_iv,
      s_sign_key: server_signing_key,
      s_enc_key: server_encrypting_key,
      s_init_vector: server_iv
    }
  end

  def asym_sign(data, pk) do
    :public_key.sign(data, :sha256, pk)
  end

  def sym_sign(data, key) do
    :crypto.mac(:hmac, :sha256, key, data)
  end

  # TODO: Currently verify needs the full message to verify
  def asym_verify(data, _pk) do
    # _sig = binary_part(data, byte_size(data) - 256, 256)
    data = binary_part(data, 0, byte_size(data) - 256)
    {true, data}
    # {:public_key.verify(data, :sha256, sig, pk), data}
  end

  def sym_verify(data, _key) do
    <<_sig::binary>> = binary_part(data, byte_size(data) - 33, 32)
    data = binary_part(data, 0, byte_size(data) - 33)
    {true, data}
  end

  def asym_pad(data) do
    # padding needed to fit perfectly into encryption chunks (214 bytes = 256bytes encrypted)
    padding_size =
      @rsa_encrypt_block_size -
        rem(byte_size(data) + @signature_size_rsa2048 + 1, @rsa_encrypt_block_size)

    data <> to_string(List.duplicate(padding_size, padding_size + 1))
  end

  def sym_pad(data) do
    # padding needed to fit perfectly into encryption chunks 16 byte chunks
    padding_size =
      @sym_encrypt_block_size -
        rem(byte_size(data) + @signature_size_sha256 + 1, @sym_encrypt_block_size)

    data <> to_string(:string.chars(padding_size, padding_size + 1))
  end

  def asym_payload_size(data) do
    floor((byte_size(data) + @signature_size_rsa2048) / 214 * 256)
  end

  def sym_payload_size(data), do: byte_size(data) + @signature_size_sha256

  defp p_hash(secret, seed, n_bytes, previous_hash \\ <<>>, hash_acc \\ <<>>)

  defp p_hash(secret, seed, n_bytes, <<>>, hash_acc) when byte_size(hash_acc) < n_bytes do
    previous_hash = :crypto.mac(:hmac, :sha256, secret, seed)
    hash_acc = hash_acc <> :crypto.mac(:hmac, :sha256, secret, previous_hash <> seed)
    p_hash(secret, seed, n_bytes, previous_hash, hash_acc)
  end

  defp p_hash(secret, seed, n_bytes, previous_hash, hash_acc)
       when byte_size(hash_acc) < n_bytes do
    previous_hash = :crypto.mac(:hmac, :sha256, secret, previous_hash)
    hash_acc = hash_acc <> :crypto.mac(:hmac, :sha256, secret, previous_hash <> seed)
    p_hash(secret, seed, n_bytes, previous_hash, hash_acc)
  end

  defp p_hash(_, _, _, _, hash_acc), do: hash_acc
end
