defmodule ExOpcua.ParameterTypes.ApplicationDescription do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Application Description Parameter Type
  	https://reference.opcfoundation.org/v104/Core/docs/Part4/7.1
  """
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.{LocalizedText, OpcString}
  alias ExOpcua.DataTypes.Array

  defstruct [
    :application_uri,
    :product_uri,
    :application_name,
    :application_type,
    :gateway_server_uri,
    :discovery_profile_uri,
    :discovery_urls
  ]

  @type t :: %__MODULE__{
          application_uri: String.t(),
          product_uri: String.t(),
          application_name: String.t(),
          application_type: atom(),
          gateway_server_uri: String.t(),
          discovery_profile_uri: String.t(),
          discovery_urls: [String.t()]
        }

  @application_types [:server, :client, :client_and_server, :discovery_server]
  # @doc """
  # 	Takes in an application description and returns the OPCUA binary representation.
  # """

  # @spec encode(any()) :: binary()
  # def encode() do
  # end

  @doc """
  	Takes in a binary beginning with an Application Description
  	Returns a tuple of the Application Description and remaining binary
  """
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {:error, binary()}
  def take(<<deserialize_string(app_uri), deserialize_string(product_uri), rest::binary>>) do
    with {application_name, rest} <- LocalizedText.take(rest),
         {application_type, rest} <- take_application_type(rest),
         {gateway_server_uri, rest} <- OpcString.take(rest),
         {discovery_profile_uri, rest} <- OpcString.take(rest),
         {discovery_urls, rest} <- Array.take(rest, &OpcString.take/1) do
      {
        %__MODULE__{
          application_uri: app_uri,
          product_uri: product_uri,
          application_type: application_type,
          application_name: application_name,
          gateway_server_uri: gateway_server_uri,
          discovery_profile_uri: discovery_profile_uri,
          discovery_urls: discovery_urls
        },
        rest
      }
    end
  end

  defp take_application_type(<<app_type::int(32), rest::binary>>) do
    {Enum.at(@application_types, app_type), rest}
  end
end
