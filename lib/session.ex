defmodule ExOpcua.Session do
  use GenServer
  alias ExOpcua.Protocol.Headers
  alias ExOpcua.Protocol

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
         {:ok, state} <- initiate_hello(state),
         {:ok, state} <- create_secure_connection(state),
         {:ok, state} <- create_session(state),
         {:ok, state} <- activate_session(state) do
      # :inet.setopts(socket, active: true)
      {:ok, state}
    else
      reason -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_info({:tcp, _socket, packet}, %{handler: handler} = state) do
    # :ok =
    #   packet
    #   |> Protocol.decode_recieved()
    #   |> handler.handle_payload()

    {:noreply, state}
  end

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
  def handle_cast(:send, %{socket: socket, url: url} = s) do
    :gen_tcp.send(socket, Protocol.encode_message(:browse_request, s))
    {:noreply, s}
  end

  defp initiate_hello(%{socket: socket, url: url} = state) do
    with hello_message <- Protocol.encode_message(:hello, %{url: url}),
         :ok <- :gen_tcp.send(socket, hello_message),
         {:ok, %{header: %Headers.HelloHeader{}} = decoded_ack} <-
           Protocol.recieve_message(socket) do
      {:ok, state}
    else
      reason -> {:hello_error, reason}
    end
  end

  defp create_secure_connection(%{socket: socket, req_id: req_id, seq_number: seq_number} = state) do
    req_id = req_id + 1
    seq_number = seq_number + 1

    with secure_connection_request <-
           Protocol.encode_message(:open_secure_channel, %{
             sec_policy: "http://opcfoundation.org/UA/SecurityPolicy#None",
             req_id: req_id,
             seq_number: seq_number
           }),
         :ok <- :gen_tcp.send(socket, secure_connection_request),
         {:ok,
          %{
            header: %Headers.OpenSecureChannelHeader{
              sender_cert: scert,
              recv_cert: rcert
            },
            payload: %{
              sec_channel_id: sci,
              token_id: token_id,
              revised_lifetime_in_ms: revised_lifetime_in_ms
            }
          }} <- Protocol.recieve_message(socket) do
      {:ok,
       %{
         state
         | sec_channel_id: sci,
           token_id: token_id,
           req_id: req_id,
           seq_number: seq_number,
           sender_cert: scert,
           recv_cert: rcert,
           revised_lifetime_in_ms: revised_lifetime_in_ms
       }}
    else
      reason -> {:secure_connect_error, reason}
    end
  end

  defp create_session(
         %{
           socket: socket,
           sec_channel_id: sec_channel_id,
           req_id: req_id,
           seq_number: seq_number,
           token_id: token_id,
           url: url
         } = state
       ) do
    req_id = req_id + 1
    seq_number = seq_number + 1

    with session_request <-
           Protocol.encode_message(:open_session, %{
             sec_channel_id: sec_channel_id,
             token_id: token_id,
             url: url,
             req_id: req_id,
             seq_number: seq_number
           }),
         :ok <- :gen_tcp.send(socket, session_request),
         {:ok,
          %{
            payload: %{
              session_id: _session_id,
              auth_token: auth_token,
              revised_session_timeout: _revised_session_timeout
            }
          }} <- Protocol.recieve_message(socket, req_id) do
      {:ok, %{state | auth_token: auth_token, req_id: req_id, seq_number: seq_number}}
    else
      reason -> {:session_error, reason}
    end
  end

  defp activate_session(
         %{
           socket: socket,
           auth_token: auth_token,
           sec_channel_id: sec_channel_id,
           req_id: req_id,
           seq_number: seq_number,
           token_id: token_id,
           url: url
         } = state
       ) do
    req_id = req_id + 1
    seq_number = seq_number + 1

    with session_request <-
           Protocol.encode_message(:activate_session, %{
             sec_channel_id: sec_channel_id,
             token_id: token_id,
             auth_token: auth_token,
             req_id: req_id,
             seq_number: seq_number
           }),
         :ok <- :gen_tcp.send(socket, session_request),
         {:ok, %{payload: :activated}} <- Protocol.recieve_message(socket) do
      IO.puts("Session Activated")
      {:ok, %{state | req_id: req_id, seq_number: seq_number}}
    else
      reason -> {:activate_session_error, reason}
    end
  end
end
