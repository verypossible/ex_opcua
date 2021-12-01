defmodule ExOpcua.Encryption do
  @supported_profiles [:none, :basic256_Sha256]
  @supported_security_modes [:none, :sign_encrypt]

  @spec new(atom(), atom()) :: any()
  def new(sec_mode \\ :none, sec_profile \\ :none)

  def new(:none, :none) do
  end

  def new(:sign_encrypt, :basic256_Sha256) do
  end
end
