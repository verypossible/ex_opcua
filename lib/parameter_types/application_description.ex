defmodule ExOpcua.ParameterTypes.ApplicationDescription do
  # require ExOpcua.DataTypes.BuiltInDataTypes.Macros
  # alias ExOpcua.DataTypes.BuiltInDataTypes

  # @moduledoc """
  # 	Defines the structure template and decodings/encodings for
  # 	the OPCUA Application Description Parameter Type
  # 	https://reference.opcfoundation.org/v104/Core/docs/Part4/7.1
  # """
  # defmodule Template do
  #   defstruct [
  #     :application_uri,
  #     :product_uri,
  #     :application_name,
  #     :application_type,
  #     :gateway_server_uri,
  #     :discovery_profile_uri,
  #     :discovery_urls
  #   ]
  # end

  # @doc """
  # 	Takes in an application description and returns the OPCUA binary representation.
  # """

  # @spec encode(any()) :: binary()
  # def encode() do
  # end

  # @doc """
  # 	Takes in a binary and returns the ApplicationDescription structure.
  # """

  # @spec decode(binary()) :: Template | :error
  # def decode() do
  # end

  # @doc """
  # 	Takes in a binary beginning with an Application Description
  # 	Returns a tuple of the Application Description and remaining binary
  # """
  # @spec take(binary()) :: {%Template{}, binary()} | {:error, binary()}
  # def take(
  #       <<BuiltInDataTypes.deserialize_string(app_uri),
  #         BuiltInDataTypes.deserialize_string(product_uri), application_name>>
  #     ) do

  # end
end
