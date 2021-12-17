defmodule ExOpcua.SecurityProfile.Encryption do
  @callback uri() :: binary()
  @callback asym_decrypt(encrypted_data :: binary(), key :: any()) :: binary()
  @callback sym_decrypt(encrypted_data :: binary(), key :: any()) :: binary()
  @callback asym_encrypt(data :: binary(), key :: any()) :: binary()
  @callback sym_encrypt(data :: binary(), key :: any(), init_vector :: binary()) :: binary()
  @callback asym_sign(data :: binary(), key :: any()) :: binary()
  @callback sym_sign(data :: binary(), key :: any()) :: binary()
  @callback asym_verify(data :: binary(), key :: any()) :: {boolean(), binary()}
  @callback sym_verify(data :: binary(), key :: any()) :: {boolean(), binary()}
  @callback asym_pad(data :: binary()) :: binary()
  @callback sym_pad(data :: binary()) :: binary()
  @callback asym_payload_size(data :: binary()) :: binary()
  @callback sym_payload_size(data :: binary()) :: binary()
  @callback derive_sym_keys(client_nonce :: binary(), server_nonce :: binary) :: %{}
  # @callback validate_signature(data :: binary()) :: {boolean(), binary()}

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour ExOpcua.SecurityProfile.Encryption
      def asym_decrypt(data, _key \\ nil), do: data

      def sym_decrypt(data, _key \\ nil), do: data

      def asym_encrypt(data, _key \\ nil), do: data

      def sym_encrypt(data, _key \\ nil, _init_vector \\ nil), do: data

      def asym_sign(_data, _key \\ nil), do: <<>>

      def sym_sign(_data, _key \\ nil), do: <<>>

      def asym_verify(data, _key), do: {true, data}
      def sym_verify(data, _key), do: {true, data}

      def asym_pad(data), do: data
      def sym_pad(data), do: data

      def asym_payload_size(data), do: byte_size(data)

      def sym_payload_size(data), do: byte_size(data)

      def derive_sym_keys(_c_nonce, _s_nonce), do: %{}
      defoverridable ExOpcua.SecurityProfile.Encryption
    end
  end
end
