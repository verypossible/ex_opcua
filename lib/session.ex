defmodule ExOpcua.Session do
  use GenServer
  alias ExOpcua.Protocol.{HelloHeader, OpenSecureChannelHeader, MSGHeader}
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
    url = opts[:url] || "opc.tcp://" <> ip <> ":" <> Integer.to_string(port)
    handler = opts[:handler] || ExOpcua.Session.Handler
    GenServer.start_link(__MODULE__, [ip, port, url, handler], [])
  end

  @impl GenServer
  def init([ip, port, url, handler]) do
    hello_message = Protocol.encode_message(:hello, %{url: url})

    secure_connection_request =
      Protocol.encode_message(:open_secure_channel, %{
        sec_policy: "http://opcfoundation.org/UA/SecurityPolicy#None"
      })

    with {:ok, socket} <-
           :gen_tcp.connect(
             ip |> String.to_charlist(),
             port,
             [packet: :raw, mode: :binary, active: false, keepalive: true],
             10_000
           ),
         :ok <- :gen_tcp.send(socket, hello_message),
         {:ok, hello_ack} <- :gen_tcp.recv(socket, 0, 10_000),
         {:ok, %{header: %HelloHeader{}}} <- Protocol.decode_recieved(hello_ack),
         :ok <- :gen_tcp.send(socket, secure_connection_request),
         {:ok, secure_connect_response} <- :gen_tcp.recv(socket, 0, 10_000),
         {:ok,
          %{
            header: %OpenSecureChannelHeader{
              sec_channel_id: sci,
              seq_number: seq_num,
              req_id: req_id,
              sender_cert: scert,
              recv_cert: rcert
            }
          }} <- Protocol.decode_recieved(secure_connect_response) do
      :inet.setopts(socket, active: true)

      {:ok,
       %{
         handler: handler,
         socket: socket,
         sec_channel_id: sci,
         seq_number: seq_num,
         req_id: req_id,
         sender_cert: scert,
         recv_cert: rcert,
         url: url
       }}
    else
      reason -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_info({:tcp, _socket, packet}, %{handler: handler} = state) do
    :ok =
      packet
      |> Protocol.decode_recieved(packet)
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
    message =
      <<0x4D, 0x53, 0x47, 0x46, 0x67, 0x00, 0x00, 0x00, 0x6A, 0xA9, 0xCD, 0x22, 0x01, 0x00, 0x00,
        0x00, 0x6E, 0x00, 0x00, 0x00, 0x6E, 0x00, 0x00, 0x00, 0x01, 0x00, 0x0F, 0x02, 0x02, 0x00,
        0x00, 0x3B, 0xDA, 0x04, 0x22, 0x20, 0x26, 0xC7, 0x49, 0x0A, 0x48, 0xD7, 0x01, 0x6E, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x30, 0x75, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0xE8, 0x03, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0xC0, 0x2D, 0x02, 0x00,
        0x00, 0x00, 0x00, 0x1F, 0x01, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x00, 0x00, 0x00>>

    :ok = :gen_tcp.send(socket, message)
    {:noreply, s}
  end
end
