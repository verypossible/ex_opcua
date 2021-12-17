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
end
