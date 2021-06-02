defmodule ExOpcua.Session do
  use GenServer
  alias ExOpcua.Protocol.{HelloHeader, OpenSecureChannelHeader, MSGHeader, Headers}
  alias ExOpcua.Protocol

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
    with {:ok, socket} <-
           :gen_tcp.connect(
             ip |> String.to_charlist(),
             port,
             [packet: :raw, mode: :binary, active: false, keepalive: true],
             10_000
           ),
         {:ok, %{header: %HelloHeader{}}} <- initiate_hello(socket, url),
         {:ok,
          %{
            header:
              %OpenSecureChannelHeader{
                sender_cert: scert,
                recv_cert: rcert
              } = secure_channel_info,
            payload: %{
              sec_channel_id: sci,
              token_id: token_id,
              revised_lifetime_in_ms: revised_lifetime_in_ms
            }
          }} <- create_secure_connection(socket),
         {:ok,
          %{
            payload: %{
              session_id: _session_id,
              auth_token: auth_token,
              revised_session_timeout: _revised_session_timeout
            }
          }} <-
           create_session(socket, sci, token_id, url),
         {:ok, session} <- activate_session(socket, sci, token_id, auth_token) do
      :inet.setopts(socket, active: true)

      {:ok,
       %{
         handler: handler,
         socket: socket,
         sec_channel_id: sci,
         sec_token_id: token_id,
         revised_lifetime_in_ms: revised_lifetime_in_ms,
         sender_cert: scert,
         recv_cert: rcert,
         url: url
       }}
    else
      reason -> {:stop, reason}
    end
  end

  defp initiate_hello(socket, url) do
    with hello_message <- Protocol.encode_message(:hello, %{url: url}),
         :ok <- :gen_tcp.send(socket, hello_message),
         {:ok, %{header: %HelloHeader{}} = decoded_ack} <-
           Protocol.recieve_message(socket, nil, <<>>) do
      {:ok, decoded_ack}
    else
      reason -> {:hello_error, reason}
    end
  end

  defp create_secure_connection(socket) do
    with secure_connection_request <-
           Protocol.encode_message(:open_secure_channel, %{
             sec_policy: "http://opcfoundation.org/UA/SecurityPolicy#None"
           }),
         :ok <- :gen_tcp.send(socket, secure_connection_request),
         {:ok,
          %{
            header: %OpenSecureChannelHeader{
              sec_channel_id: sci,
              req_id: req_id,
              sender_cert: scert,
              recv_cert: rcert
            }
          } = decoded_ack} <- Protocol.recieve_message(socket) do
      {:ok, decoded_ack}
    else
      reason -> {:secure_connect_error, reason}
    end
  end

  defp create_session(socket, sec_channel_id, token_id, url) do
    with session_request <-
           Protocol.encode_message(:open_session, %{
             sec_channel_id: sec_channel_id,
             token_id: token_id,
             url: url
           }),
         :ok <- :gen_tcp.send(socket, session_request),
         {:ok, session_response} <- Protocol.recieve_message(socket) do
      {:ok, session_response}
    else
      reason -> {:session_error, reason}
    end
  end

  defp activate_session(socket, sec_channel_id, token_id, auth_token) do
    with session_request <-
           Protocol.encode_message(:activate_session, %{
             sec_channel_id: sec_channel_id,
             token_id: token_id,
             auth_token: auth_token
           }),
         :ok <- :gen_tcp.send(socket, session_request),
         {:ok, session_response} <- Protocol.recieve_message(socket) do
      {:ok, session_response}
    else
      reason -> {:session_error, reason}
    end
  end

  @impl GenServer
  def handle_info({:tcp, _socket, packet}, %{handler: handler} = state) do
    :ok =
      packet
      |> Protocol.decode_recieved()
      |> handler.handle_payload()

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
    {:noreply, s}
  end
end
