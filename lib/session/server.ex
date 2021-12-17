defmodule ExOpcua.Session.Server do
  use GenServer
  alias ExOpcua.Protocol
  alias ExOpcua.Services
  alias ExOpcua.Session
  alias ExOpcua.Session.State

  @impl GenServer
  def init(%State{} = state) do
    with {:ok, socket} <-
           :gen_tcp.connect(
             state.ip |> String.to_charlist(),
             state.port,
             [packet: :raw, mode: :binary, active: false, keepalive: true],
             10_000
           ),
         %State{} = state <- %{state | socket: socket},
         %State{} = state <- Session.initiate_hello(state),
         %State{} = state <- Session.create_secure_connection(state),
         %State{} = state <- Session.create_session(state),
         %State{} = state <- Session.activate_session(state) do
      {:ok, state}
    else
      reason -> {:stop, reason}
    end
  end

  # def terminate(reason, state) do
  #   IO.puts("Server Shutting Down NOW!!!")
  #   state = Session.close_secure_connection(state)
  # end

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

  # # TODO: Just a garbage message for testing currently
  # @impl GenServer
  # def handle_cast(:send, %{socket: socket} = s) do
  #   s = Session.check_session(s)
  #   :gen_tcp.send(socket, Protocol.encode_message(:browse_request, s))
  #   result = Protocol.recieve_message(socket)
  #   IO.inspect(result)
  #   {:noreply, s}
  # end

  @impl GenServer
  def handle_call({:read_all, node_ids}, _from, %{socket: socket} = s) do
    s = Session.check_session(s)

    {s, req} =
      node_ids
      |> Services.Read.encode_read_all(s)
      |> Protocol.build_symetric_packet(s)

    :gen_tcp.send(socket, req)

    {:ok, %{payload: result}} = Protocol.recieve_message(s)

    {:reply, result, s}
  end

  @impl GenServer
  def handle_call({:read_attrs, node_ids, attrs}, _from, %{socket: socket} = s) do
    s = Session.check_session(s)

    {s, req} =
      node_ids
      |> Services.Read.encode_read_attrs(s, attrs)
      |> Protocol.build_symetric_packet(s)

    :gen_tcp.send(socket, req)

    {:ok, %{payload: result}} = Protocol.recieve_message(s)

    {:reply, result, s}
  end

  @impl GenServer
  def handle_call(:close_session, _from, s) do
    Session.close_session(s)
    {:reply, "session_closed", s}
  end
end
