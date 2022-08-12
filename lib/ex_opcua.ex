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
  alias ExOpcua.DataTypes.EndpointDescription
  import ExOpcua.Protocol.RootNamespaceNodeIDMappings

  def start_session(opts \\ []) do
    Session.start_session(opts)
  end

  def send(pid) do
    GenServer.cast(pid, :send)
  end

  def read(pid) do
    GenServer.call(pid, :read)
  end

  def close_session(pid) do
    GenServer.call(pid, :close_session)
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

  def browse(node_id, pid, opts \\ []) do
    GenServer.call(pid, {:browse, node_id, opts})
  end

  @spec discover_endpoints(binary(), integer(), binary()) :: [%EndpointDescription{}]
  def discover_endpoints(url) when is_binary(url) do
    %{host: host, port: port} = URI.parse(url)

    {:ok, {octet_1, octet_2, octet_3, octet_4}} =
      host
      |> String.to_charlist()
      |> :inet.getaddr(:inet)

    port = port || 4840
    discover_endpoints("#{octet_1}.#{octet_2}.#{octet_3}.#{octet_4}", port, url)
  end

  def discover_endpoints(ip, port, url \\ nil) do
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

  # def setup_session() do
  #   e =
  #     ExOpcua.discover_endpoints(
  #       "opc.tcp://Kalebs-MacBook-Pro.local:53530/OPCUA/SimulationServer"
  #     )
  #     |> Enum.find(
  #       &match?(%{sec_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#None"}, &1)
  #     )

  #   {:ok, pid} = ExOpcua.start_session(e)

  #   b = %ExOpcua.DataTypes.BrowseDescription{
  #     browse_direction: :forward,
  #     include_subtypes: true,
  #     node_class_mask: 0,
  #     node_id: %ExOpcua.DataTypes.NodeId{
  #       encoding_mask: 1,
  #       identifier: 23470,
  #       namespace_idx: 0,
  #       server_idx: nil,
  #       server_uri: nil
  #     },
  #     reference_type_id: %{encoding_mask: 0, identifier: 35},
  #     result_mask: 31
  #   }

  #   {e, pid, b}
  # end

# ExOpcua.discover_endpoints("opc.tcp://Kalebs-MacBook-Pro.local:53530/OPCUA/SimulationServer") |> Enum.find(&match?(%{sec_policy_uri: "http://opcfoundation.org/UA/SecurityPolicy#None"}, &1))
