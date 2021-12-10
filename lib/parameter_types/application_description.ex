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
    :app_uri,
    :product_uri,
    :app_name,
    :app_type,
    :gateway_server_uri,
    :discovery_profile_uri,
    :discovery_urls
  ]

  @type t :: %__MODULE__{
          app_uri: String.t(),
          product_uri: String.t(),
          app_name: String.t(),
          app_type: atom(),
          gateway_server_uri: String.t(),
          discovery_profile_uri: String.t(),
          discovery_urls: [String.t()]
        }

  @app_types [:server, :client, :client_and_server, :discovery_server]

  @doc """
  	Takes in a binary beginning with an Application Description
  	Returns a tuple of the Application Description and remaining binary
  """
  @spec take(binary()) :: {%__MODULE__{}, binary()} | {:error, binary()}
  def take(binary) when is_binary(binary) do
    with {app_uri, rest} <- OpcString.take(binary),
         {product_uri, rest} <- OpcString.take(rest),
         {app_name, rest} <- LocalizedText.take(rest),
         {app_type, rest} <- take_app_type(rest),
         {gateway_server_uri, rest} <- OpcString.take(rest),
         {discovery_profile_uri, rest} <- OpcString.take(rest),
         {discovery_urls, rest} <- Array.take(rest, &OpcString.take/1) do
      {
        %__MODULE__{
          app_uri: app_uri,
          product_uri: product_uri,
          app_type: app_type,
          app_name: app_name,
          gateway_server_uri: gateway_server_uri,
          discovery_profile_uri: discovery_profile_uri,
          discovery_urls: discovery_urls
        },
        rest
      }
    end
  end

  @doc """
    Serialize function for converting an ApplicationDescription to OPCUA Binary representation

    If no argument is given (or nil) this function returns the library defaults
  """
  @spec serialize(map() | nil) :: binary()
  def serialize(application_description \\ nil)

  def serialize(nil) do
    <<
      serialize_string("urn:helios.local:OPCUA"),
      serialize_string("urn:helios.local:OPCUA"),
      LocalizedText.serialize("ex_opcua")::binary,
      # application type client
      1::int(32),
      # additional null values 0xFF
      opc_null_value(),
      opc_null_value(),
      opc_null_value()
    >>
  end

  def serialize(%{
        app_uri: app_uri,
        product_uri: p_uri,
        app_name: name,
        app_type: type,
        gateway_server_uri: gs_uri,
        discovery_profile_uri: dp_uri,
        discovery_urls: d_urls
      }) do
    <<
      OpcString.serialize(app_uri)::binary,
      OpcString.serialize(p_uri)::binary,
      LocalizedText.serialize(name)::binary,
      # application type client
      Enum.find_index(@app_types, &(&1 === type))::int(32),
      OpcString.serialize(gs_uri)::binary,
      OpcString.serialize(dp_uri)::binary,
      Array.serialize(d_urls, &OpcString.serialize/1)::binary
    >>
  end

  def serialize(_) do
    opc_null_value()
  end

  defp take_app_type(<<app_type::int(32), rest::binary>>) do
    {Enum.at(@app_types, app_type), rest}
  end
end
