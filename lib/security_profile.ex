defmodule ExOpcua.SecurityProfile do
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString
  alias ExOpcua.SecurityProfile.Encryption

  @supported_profiles %{
    none: Encryption.None,
    basic256_Sha256: Encryption.Basic256Sha256
  }

  @sec_profile_uris %{
    "http://opcfoundation.org/UA/SecurityPolicy#None" => :none,
    "http://opcfoundation.org/UA/SecurityPolicy#Basic256Sha256" => :basic256_Sha256
  }

  defstruct sec_mode: :none,
            encrypt_mod: Encryption.None,
            client_priv_key: nil,
            client_pub_key: nil,
            server_pub_key: nil,
            server_thumbprint: nil,
            client_nonce: nil,
            server_nonce: nil,
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
          encrypt_mod: module(),
          client_priv_key: X509.PrivateKey.t(),
          client_pub_key: binary(),
          server_pub_key: X509.PublicKey.t(),
          server_thumbprint: binary(),
          client_nonce: binary(),
          server_nonce: binary(),
          sym_keys: %{
            c_sign_key: binary(),
            c_enc_key: binary(),
            c_init_vector: binary(),
            s_sign_key: binary(),
            s_enc_key: binary(),
            s_init_vector: binary()
          }
        }

  @spec new(
          atom(),
          atom(),
          server_pub_key_der :: binary(),
          client_key_der :: binary(),
          client_cert_der :: binary()
        ) ::
          {:ok, __MODULE__.t()} | {:error, binary()}
  def new(
        sec_mode \\ :none,
        sec_profile \\ :none,
        client_private_key \\ nil,
        client_cert_der \\ nil,
        server_public_key \\ nil
      )

  def new(:none, _, _, _, _), do: {:ok, %__MODULE__{}}
  def new(_, :none, _, _, _), do: {:ok, %__MODULE__{}}

  def new(:sign_encrypt, sec_profile, server_pub_key_der, client_key_der, client_cert_der)
      when is_map_key(@supported_profiles, sec_profile) do
    client_priv_key = X509.PrivateKey.from_der!(client_key_der)

    server_pub_key =
      server_pub_key_der
      |> X509.Certificate.from_der!()
      |> X509.Certificate.public_key()

    {:ok,
     %__MODULE__{
       sec_mode: :sign_encrypt,
       encrypt_mod: Map.get(@supported_profiles, sec_profile),
       client_priv_key: client_priv_key,
       client_pub_key: client_cert_der,
       server_pub_key: server_pub_key,
       server_thumbprint: :crypto.hash(:sha, server_pub_key_der),
       client_nonce: :crypto.strong_rand_bytes(32)
     }}
  end

  def new(sec_mode, sec_profile, _, _, _) do
    {:error, "#{inspect(sec_profile)} not supported by #{inspect(sec_mode)}"}
  end

  def decode_sec_policy_uri(sec_policy_uri) do
    Map.get(@sec_profile_uris, sec_policy_uri, :none)
  end

  @spec asymetric_security_header(__MODULE__.t()) :: binary()
  def asymetric_security_header(%__MODULE__{} = sec_profile) do
    <<
      OpcString.serialize(sec_profile.encrypt_mod.uri())::binary,
      OpcString.serialize(sec_profile.client_pub_key)::binary,
      OpcString.serialize(sec_profile.server_thumbprint)::binary
    >>
  end

  @spec sign(binary(), __MODULE__.t(), :asym | :sym) :: {boolean(), binary()}
  def sign(data, sec_profile, method \\ :asym)
  def sign(_, %{sec_mode: :none}, _), do: <<>>
  def sign(d, %{client_priv_key: k, encrypt_mod: m}, :asym), do: m.asym_sign(d, k)
  def sign(d, %{sym_keys: %{c_sign_key: k}, encrypt_mod: m}, :sym), do: m.sym_sign(d, k)

  @spec verify_signature(binary(), __MODULE__.t(), :asym | :sym) ::
          binary() | {:error, :bad_signature}
  def verify_signature(data, sec_profile, method \\ :asym)
  def verify_signature(data, %{sec_mode: :none}, _), do: {true, data}
  def verify_signature(d, %{encrypt_mod: m, server_pub_key: k}, :asym), do: m.asym_verify(d, k)

  def verify_signature(d, %{encrypt_mod: m, sym_keys: %{s_sign_key: k}}, :sym) do
    m.sym_verify(d, k)
  end

  @spec encrypt(binary(), __MODULE__.t(), binary()) :: binary()
  def encrypt(data, sec_profile, method \\ :asym)
  def encrypt(data, %{sec_mode: :none}, _), do: data
  def encrypt(d, %{server_pub_key: k, encrypt_mod: m}, :asym), do: m.asym_encrypt(d, k)

  def encrypt(d, %{sym_keys: %{c_enc_key: k, c_init_vector: v}, encrypt_mod: m}, :sym) do
    m.sym_encrypt(d, k, v)
  end

  @spec decrypt(binary(), __MODULE__.t()) :: binary()
  def decrypt(data, sec_profile, method \\ :asym)
  def decrypt(data, %{sec_mode: :none}, _), do: data
  def decrypt(d, %{client_priv_key: k, encrypt_mod: m}, :asym), do: m.asym_decrypt(d, k)

  def decrypt(d, %{sym_keys: %{s_enc_key: k, s_init_vector: v}, encrypt_mod: m}, :sym) do
    m.sym_decrypt(d, k, v)
  end

  @spec derive_sym_keys(__MODULE__.t(), binary()) :: __MODULE__.t()
  def derive_sym_keys(%{client_nonce: c_nonce, encrypt_mod: mod} = sp, s_nonce) do
    %{sp | sym_keys: mod.derive_sym_keys(c_nonce, s_nonce)}
  end

  @spec pad(binary(), __MODULE__.t()) :: binary()
  def pad(_, _, method \\ :asym)
  def pad(data, %{sec_mode: :none}, _), do: data
  def pad(data, %{encrypt_mod: m}, :asym), do: m.asym_pad(data)
  def pad(data, %{encrypt_mod: m}, :sym), do: m.sym_pad(data)

  @spec encrypted_payload_size(binary(), __MODULE__.t()) :: integer()
  def encrypted_payload_size(data, sec_profile, method \\ :asym)
  def encrypted_payload_size(data, %{sec_mode: :none}, _), do: byte_size(data)
  def encrypted_payload_size(data, %{encrypt_mod: m}, :asym), do: m.asym_payload_size(data)
  def encrypted_payload_size(data, %{encrypt_mod: m}, :sym), do: m.sym_payload_size(data)
end
