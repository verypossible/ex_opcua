defmodule ExOpcua do
  @moduledoc """
  Documentation for `ExOpcua`.
  """

  @doc """
  Library functions for OPC UA Lib.
  """
  alias ExOpcua.Session
  alias ExOpcua.Services.Read
  alias ExOpcua.DataTypes.NodeId
  alias ExOpcua.ParameterTypes.EndpointDescription

  def start_session(opts \\ []) do
    Session.start_session(opts)
  end

  def send(pid) do
    GenServer.cast(pid, :send)
  end

  def read(pid) do
    GenServer.call(pid, :read)
  end

  @spec read_all_attrs(List.t(), pid(), Atom.t()) :: map()
  def read_all_attrs(node_ids, pid, format \\ :pretty)

  def read_all_attrs([node | _rest] = nodeids, pid, format) when is_binary(node) do
    nodeids
    |> Enum.map(&NodeId.parse/1)
    |> read_all_attrs(pid, format)
  end

  def read_all_attrs(node_ids, pid, format) when is_list(node_ids) do
    # 1..27 come back in order
    # https://reference.opcfoundation.org/v104/Core/docs/Part6/A.1/
    GenServer.call(pid, {:read_all, node_ids})
    |> Read.format_output(node_ids, Read.attribute_ids(), format)
  end

  def read_all_attrs(node_id, pid, format) do
    read_all_attrs([node_id], pid, format)
    |> Read.format_output([node_id], Read.attribute_ids(), format)
  end

  @spec read_attrs(List.t(), pid(), list(Atom.t()), Atom.t()) :: map()
  def read_attrs(node_ids, pid, attrs \\ [:browse_name, :value], format \\ :pretty)

  def read_attrs([node | _rest] = nodeids, pid, attrs, format) when is_binary(node) do
    nodeids
    |> Enum.map(&NodeId.parse/1)
    |> read_attrs(pid, attrs, format)
  end

  def read_attrs(node_ids, pid, attrs, format) when is_list(node_ids) do
    GenServer.call(pid, {:read_attrs, node_ids, attrs})
    |> Read.format_output(node_ids, attrs, format)
  end

  def read_attrs(node_id, pid, attrs, format) do
    read_attrs([node_id], pid, attrs, format)
  end

  @spec discover_endpoints(binary(), integer(), binary()) :: [%EndpointDescription{}]
  def discover_endpoints(ip, port \\ 4840, url \\ nil) when is_binary(ip) do
    url = url || "opc.tcp://" <> ip <> ":" <> "#{port}"
    # initial values
    state = %Session.State{url: url, ip: ip, port: port}

    with {:ok, socket} <-
           :gen_tcp.connect(
             ip |> String.to_charlist(),
             port,
             [packet: :raw, mode: :binary, active: false, keepalive: true],
             10_000
           ),
         %Session.State{} = state <- %{state | socket: socket},
         %Session.State{} = state <- Session.initiate_hello(state),
         %Session.State{} = state <- Session.create_secure_connection(state),
         {%Session.State{} = state, endpoints} <- Session.get_endpoints(state),
         Session.close_secure_connection(state) do
      endpoints
    end
  end

  def endpoint() do
    %ExOpcua.ParameterTypes.EndpointDescription{
      message_sec_mode: :sign,
      sec_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#Basic256Sha256",
      security_level: 1,
      server: %ExOpcua.ParameterTypes.ApplicationDescription{
        app_name: "SimulationServer@Kalebs-MacBook-Pro",
        app_type: :server,
        app_uri: "urn:Kalebs-MacBook-Pro.local:OPCUA:SimulationServer",
        discovery_profile_uri: nil,
        discovery_urls: ["opc.tcp://Kalebs-MacBook-Pro.local:53530/OPCUA/SimulationServer"],
        gateway_server_uri: nil,
        product_uri: "urn:prosysopc.com:OPCUA:SimulationServer"
      },
      server_cert: %{
        public_key:
          {:RSAPublicKey,
           17_613_116_168_005_741_559_508_673_914_679_911_427_152_126_075_015_720_884_747_549_322_715_312_277_771_805_797_246_804_608_358_133_295_364_536_958_573_402_497_218_733_093_038_152_155_852_039_778_223_294_464_307_773_355_937_317_681_021_460_052_294_644_640_439_570_330_219_521_047_950_558_571_564_401_119_785_350_013_899_486_602_675_276_714_539_219_702_336_473_312_348_831_077_166_603_806_121_401_989_067_184_409_819_454_792_343_971_931_110_008_813_654_511_443_863_286_262_701_178_634_311_212_942_466_996_381_029_141_413_688_861_764_289_232_673_917_446_735_068_497_836_269_568_722_076_137_198_235_518_366_416_701_366_986_863_857_930_617_424_754_275_421_711_493_983_881_680_996_508_284_001_271_531_990_280_778_716_858_554_997_441_653_730_398_211_999_069_310_113_576_894_613_285_930_509_050_283_983_314_963_045_475_957_932_709,
           65537},
        thumprint:
          <<91, 229, 69, 166, 39, 184, 138, 223, 99, 7, 145, 115, 112, 16, 179, 96, 51, 244, 13,
            236>>
      },
      transport_profile_uri: "http://opcfoundation.org/UA-Profile/Transport/uatcp-uasc-uabinary",
      url: "opc.tcp://Kalebs-MacBook-Pro.local:53530/OPCUA/SimulationServer",
      user_id_tokens: [
        %ExOpcua.ParameterTypes.UserTokenPolicy{
          issued_token_type: nil,
          issuer_endpoint_url: nil,
          policy_id: "username_basic128",
          security_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#Basic128Rsa15",
          user_token_type: :username
        },
        %ExOpcua.ParameterTypes.UserTokenPolicy{
          issued_token_type: nil,
          issuer_endpoint_url: nil,
          policy_id: "username_basic256",
          security_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#Basic256",
          user_token_type: :username
        },
        %ExOpcua.ParameterTypes.UserTokenPolicy{
          issued_token_type: nil,
          issuer_endpoint_url: nil,
          policy_id: "certificate_basic256",
          security_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#Basic256",
          user_token_type: :cert_x509
        },
        %ExOpcua.ParameterTypes.UserTokenPolicy{
          issued_token_type: nil,
          issuer_endpoint_url: nil,
          policy_id: "certificate_basic128",
          security_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#Basic128Rsa15",
          user_token_type: :cert_x509
        }
      ]
    }
  end
end
