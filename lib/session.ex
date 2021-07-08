defmodule ExOpcua.Session do
  use GenServer
  alias ExOpcua.Protocol
  alias ExOpcua.Session.Impl

  defmodule State do
    defstruct [
      :handler,
      :url,
      :socket,
      :sec_channel_id,
      :token_id,
      :sender_cert,
      :recv_cert,
      :revised_lifetime_in_ms,
      :auth_token,
      req_id: 0,
      seq_number: 0
    ]
  end

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
    state = %State{handler: handler, url: url}

    with {:ok, socket} <-
           :gen_tcp.connect(
             ip |> String.to_charlist(),
             port,
             [packet: :raw, mode: :binary, active: false, keepalive: true],
             10_000
           ),
         state <- %{state | socket: socket},
         {:ok, state} <- Impl.initiate_hello(state),
         {:ok, state} <- Impl.create_secure_connection(state),
         {:ok, state} <- Impl.create_session(state),
         {:ok, state} <- Impl.activate_session(state) do
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
    IO.inspect(socket, label: "connection closed dut to #{reason}")
    {:noreply, state}
  end

  # TODO: Just a garbage message for testing currently
  @impl GenServer
  def handle_cast(:send, %{socket: socket} = s) do
    :gen_tcp.send(socket, Protocol.encode_message(:browse_request, s))
    result = Protocol.recieve_message(socket)
    IO.inspect(result)
    {:noreply, s}
  end

  @impl GenServer
  def handle_call(:read, _from, %{socket: socket} = s) do
    :gen_tcp.send(socket, Protocol.encode_message(:read_request, s))
    result = Protocol.recieve_message(socket)
    {:reply, result, s}
  end

  @impl GenServer
  def handle_call({:read_all, node_id}, _from, %{socket: socket} = s) do
    :gen_tcp.send(socket, Protocol.encode_message({:read_all_request, node_id}, s))
    result = Protocol.recieve_message(socket)
    {:reply, result, s}
  end
end
