defmodule ExOpcua.Session do
  use GenServer
  alias ExOpcua.Protocol
  alias ExOpcua.Services
  alias ExOpcua.Session.Impl

  @moduledoc """
  Documentation for `ExOpcua`.
  """

  @doc """
  Main Entry Point for OPCUA communications

  ## Examples

      iex> ExOpcua.Session.start_link()
      {:ok, #PID<0,0,0>}

  """

  def start_link(opts \\ []) do
    ip = opts[:ip] || "20.0.0.170"
    port = opts[:port] || 4840

    url =
      opts[:url] ||
        "opc.tcp://" <> ip <> ":" <> Integer.to_string(port)

    handler = opts[:handler] || ExOpcua.Session.Handler
    GenServer.start_link(__MODULE__, [ip, port, url, handler], [])
  end

  @impl GenServer
  def init([ip, port, url, handler]) do
    url = url <> "/OPCUA/SimulationServer"

    # initial values
    state = %Impl.State{handler: handler, url: url}

    with {:ok, socket} <-
           :gen_tcp.connect(
             ip |> String.to_charlist(),
             port,
             [packet: :raw, mode: :binary, active: false, keepalive: true],
             10_000
           ),
         %Impl.State{} = state <- %{state | socket: socket},
         %Impl.State{} = state <- Impl.initiate_hello(state),
         %Impl.State{} = state <- Impl.create_secure_connection(state),
         %Impl.State{} = state <- Impl.create_session(state),
         %Impl.State{} = state <- Impl.activate_session(state) do
      # :inet.setopts(socket, active: true)
      {:ok, state}
    else
      reason -> {:stop, reason}
    end
  end

  # @impl GenServer
  # def handle_info({:tcp, _socket, _packet}, %{handler: _handler} = state) do
  #   # :ok =
  #   #   packet
  #   #   |> Protocol.decode_recieved()
  #   #   |> handler.handle_payload()

  #   {:noreply, state}
  # end

  @impl GenServer
  def handle_info({:tcp_closed, _socket}, state) do
    IO.inspect("Socket has been closed")
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:tcp_error, socket, reason}, state) do
    IO.inspect(socket, label: "connection closed due to #{reason}")
    {:noreply, state}
  end

  # TODO: Just a garbage message for testing currently
  @impl GenServer
  def handle_cast(:send, %{socket: socket} = s) do
    s = Impl.check_session(s)
    :gen_tcp.send(socket, Protocol.encode_message(:browse_request, s))
    result = Protocol.recieve_message(socket)
    IO.inspect(result)
    {:noreply, s}
  end

  @impl GenServer
  def handle_call({:read_all, node_id}, _from, %{socket: socket} = s) do
    s = Impl.check_session(s)
    :gen_tcp.send(socket, Services.Read.encode_read_all(node_id, s))
    {:ok, %{payload: result}} = Protocol.recieve_message(socket)
    {:reply, result, s}
  end

  @impl GenServer
  def handle_call({:read_values, node_ids}, _from, %{socket: socket} = s) do
    s = Impl.check_session(s)
    :gen_tcp.send(socket, Services.Read.encode_read_values(node_ids, s))
    {:ok, %{payload: result}} = Protocol.recieve_message(socket)
    {:reply, result, s}
  end
end
