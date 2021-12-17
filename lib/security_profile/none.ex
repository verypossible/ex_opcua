defmodule ExOpcua.SecurityProfile.Encryption.None do
  use ExOpcua.SecurityProfile.Encryption
  @policy_uri "http://opcfoundation.org/UA/SecurityPolicy#None"

  def uri(), do: @policy_uri
end
