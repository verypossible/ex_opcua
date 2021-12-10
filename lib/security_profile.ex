defmodule ExOpcua.SecurityProfile do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

  @supported_profiles [:none, :basic256_Sha256]
  @supported_security_modes [:none, :sign_encrypt]

  defstruct sec_mode: :none,
            sec_profile: :none,
            sec_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#None",
            encrypt_opts: [],
            decrypt_opts: [],
            client_priv_key: nil,
            client_pub_key: nil,
            server_pub_key: nil,
            server_thumbprint: nil,
            client_nonce: nil,
            server_nonces: nil,
            sym_keys: %{
              c_sign_key: nil,
              c_enc_key: nil,
              c_init_vector: nil,
              s_sign_key: nil,
              s_enc_key: nil,
              s_init_vector: nil
            }

  @type t :: %__MODULE__{
          sec_mode: atom(),
          sec_profile: atom(),
          sec_policy_uri: binary(),
          encrypt_opts: keyword(),
          decrypt_opts: keyword(),
          client_priv_key: X509.PrivateKey.t(),
          client_pub_key: binary(),
          server_pub_key: X509.PublicKey.t(),
          server_thumbprint: binary(),
          client_nonce: binary(),
          server_nonces: binary(),
          sym_keys: %{
            c_sign_key: binary(),
            c_enc_key: binary(),
            c_init_vector: binary(),
            s_sign_key: binary(),
            s_enc_key: binary(),
            s_init_vector: binary()
          }
        }

  @spec new(atom(), atom(), binary(), binary()) :: __MODULE__.t() | {:error, binary()}
  def new(
        sec_mode \\ :none,
        sec_profile \\ :none,
        client_private_key \\ nil,
        server_public_key \\ nil
      )

  def new(:none, :none, _, _), do: %__MODULE__{}

  def new(
        :sign_encrypt,
        :basic256_Sha256,
        client_priv_key_der,
        client_cert_der,
        server_pub_key_der
      ) do
    client_priv_key = X509.PrivateKey.from_der!(client_priv_key_der)
    # key_usage =
    #   X509.Certificate.Extension.key_usage([
    #     :digitalSignature,
    #     :keyEncipherment,
    #     :nonRepudiation,
    #     :dataEncipherment,
    #     :keyCertSign
    #   ])

    # client_public_key =
    #   client_private_key
    #   |> X509.Certificate.self_signed("/C=US/CN=Helios", extensions: [key_usage: key_usage])
    #   |> X509.Certificate.to_der()

    server_pub_key =
      server_pub_key_der
      |> X509.Certificate.from_der!()
      |> X509.Certificate.public_key()

    %__MODULE__{
      sec_mode: :sign_encrypt,
      sec_profile: :basic256_Sha256,
      encrypt_opts: [{:rsa_pad, :rsa_pkcs1_oaep_padding}],
      decrypt_opts: [{:rsa_pad, :rsa_pkcs1_oaep_padding}],
      sec_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#Basic256Sha256",
      client_priv_key: client_priv_key,
      client_pub_key: client_cert_der,
      server_pub_key: server_pub_key,
      server_thumbprint: :crypto.hash(:sha, server_pub_key_der),
      client_nonce: :crypto.strong_rand_bytes(32)
    }
  end

  def new(sec_mode, sec_profile, _, _, _) do
    {:error, "#{inspect(sec_profile)} not supported by #{inspect(sec_mode)}"}
  end

  def asymetric_security_header(%__MODULE__{} = sec_profile) do
    <<
      OpcString.serialize(sec_profile.sec_policy_uri)::binary,
      OpcString.serialize(sec_profile.client_pub_key)::binary,
      OpcString.serialize(sec_profile.server_thumbprint)::binary
    >>
  end

  @spec sign(binary(), __MODULE__.t(), atom()) :: binary()
  def sign(data, sec_profile, method \\ :asym)

  def sign(data, %{sec_mode: :sign_encrypt, client_priv_key: pk}, :asym) do
    :public_key.sign(data, :sha256, pk)
  end

  def sign(data, %{sec_mode: :sign_encrypt, sym_keys: %{c_sign_key: ckey}}, :sym) do
    :crypto.mac(:hmac, :sha256, ckey, data)
  end

  def sign(_, _, _), do: <<>>

  @spec encrypt_data(binary(), __MODULE__.t(), binary()) :: binary()
  def encrypt_data(data, sec_profile, acc \\ <<>>)
  def encrypt_data(<<>>, _sp, acc), do: acc
  def encrypt_data(data, %{sec_mode: :none}, _), do: data

  def encrypt_data(<<blob::binary-size(214), rest::binary>>, %{server_pub_key: pkey} = sp, acc) do
    encrypt_data(rest, sp, acc <> :public_key.encrypt_public(blob, pkey, sp.encrypt_opts))
  end

  @spec encrypt_data(binary(), __MODULE__.t()) :: binary()
  def sym_encrypt_data(data, sec_profile)
  def sym_encrypt_data(<<>>, _sp), do: <<>>
  def sym_encrypt_data(data, %{sec_mode: :none}), do: data

  def sym_encrypt_data(blob, %{sym_keys: %{c_enc_key: c_key, c_init_vector: c_iv}}) do
    :crypto.crypto_one_time(:aes_256_cbc, c_key, c_iv, blob, true)
  end

  @spec decrypt_data(binary(), __MODULE__.t(), binary()) :: binary()
  def decrypt_data(data, sec_profile, acc \\ <<>>)
  def decrypt_data(<<>>, _private_key, acc), do: acc
  def decrypt_data(data, %{sec_mode: :none}, _), do: data

  def decrypt_data(<<blob::binary-size(256), rest::binary>>, %{client_priv_key: pkey} = sp, acc) do
    decrypt_data(rest, sp, acc <> :public_key.decrypt_private(blob, pkey, sp.decrypt_opts))
  end

  def decrypt_data(<<data::binary>>, %{client_priv_key: pkey} = sp, acc) do
    acc <> :public_key.decrypt_private(data, pkey, sp.decrypt_opts)
  end

  @spec sym_decrypt_data(binary(), __MODULE__.t()) :: binary()
  # def sym_decrypt_data(data, %{sec_mode: :none}, _), do: data

  def sym_decrypt_data(blob, %{sym_keys: %{s_enc_key: s_key, s_init_vector: s_iv}}) do
    :crypto.crypto_one_time(:aes_256_cbc, s_key, s_iv, blob, false)
  end

  @spec derive_sym_keys(__MODULE__.t(), binary()) :: __MODULE__.t()
  def derive_sym_keys(%{sec_mode: :none} = sp, _server_nonce), do: sp

  def derive_sym_keys(%{sec_mode: :sign_encrypt, client_nonce: c_nonce} = sp, s_nonce) do
    <<client_signing_key::binary-size(32), client_encrypting_key::binary-size(32),
      client_iv::binary-size(16), _rest::binary>> = p_hash(s_nonce, c_nonce, 80)

    <<server_signing_key::binary-size(32), server_encrypting_key::binary-size(32),
      server_iv::binary-size(16), _rest::binary>> = p_hash(c_nonce, s_nonce, 80)

    sym_keys = %{
      c_sign_key: client_signing_key,
      c_enc_key: client_encrypting_key,
      c_init_vector: client_iv,
      s_sign_key: server_signing_key,
      s_enc_key: server_encrypting_key,
      s_init_vector: server_iv
    }

    %{sp | sym_keys: sym_keys}
  end

  def p_hash(secret, seed, n_bytes, previous_hash \\ <<>>, hash_acc \\ <<>>)

  def p_hash(secret, seed, n_bytes, <<>>, hash_acc) when byte_size(hash_acc) < n_bytes do
    previous_hash = :crypto.mac(:hmac, :sha256, secret, seed)
    hash_acc = hash_acc <> :crypto.mac(:hmac, :sha256, secret, previous_hash <> seed)
    p_hash(secret, seed, n_bytes, previous_hash, hash_acc)
  end

  def p_hash(secret, seed, n_bytes, previous_hash, hash_acc) when byte_size(hash_acc) < n_bytes do
    previous_hash = :crypto.mac(:hmac, :sha256, secret, previous_hash)
    hash_acc = hash_acc <> :crypto.mac(:hmac, :sha256, secret, previous_hash <> seed)
    p_hash(secret, seed, n_bytes, previous_hash, hash_acc)
  end

  def p_hash(_, _, _, _, hash_acc), do: hash_acc
end
