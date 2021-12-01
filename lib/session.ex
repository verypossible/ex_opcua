defmodule ExOpcua.Session do
  alias ExOpcua.Protocol.Headers
  alias ExOpcua.Protocol
  alias ExOpcua.Services
  alias ExOpcua.ParameterTypes.EndpointDescription

  defmodule State do
    defstruct [
      :ip,
      :port,
      :handler,
      :url,
      :endpoint,
      :socket,
      :sec_channel_id,
      :token_id,
      :sender_cert,
      :recv_cert,
      :session_expire_time,
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
  ## Options

    * `:ip` - Ip Address of OPCUA Server. Defaults to `20.0.0.170`

    * `:port` - Port number of OPCUA Server. Defaults to `4840`

    * `:endpoint` - `REQUIRED` Endpoint Description for OPCUA (see `ExOpcua.discover_endpoints/1`)

    * `:handler` - Callback handler for responses. See ExOpcua.Session.Handler

    * `:encryption` - Encryption structure used by this session. See
    (see `ExOpcua.Encryption.generate/1`) Defaults to `:none`

  ## Examples

      iex> ExOpcua.Session.start_link()
      {:ok, #PID<0,0,0>}

  """

  def start_session(opts \\ []) do
    ip = opts[:ip] || "127.0.0.1"
    port = opts[:port] || 4840

    %EndpointDescription{} =
      endpoint = opts[:endpoint] || raise "Endpoint is required for session connect"

    handler = opts[:handler] || ExOpcua.Session.Handler
    encryption = opts[:encryption] || :none

    # initial values
    state = %State{
      handler: handler,
      endpoint: endpoint,
      ip: ip,
      port: port,
      url: endpoint.url
    }

    GenServer.start_link(__MODULE__.Server, state, [])
  end

  def initiate_hello(%State{socket: socket, url: url} = state) do
    with hello_message <- Protocol.encode_hello_message(url),
         :ok <- :gen_tcp.send(socket, hello_message),
         {:ok, %{header: %Headers.HelloHeader{}}} <-
           Protocol.recieve_message(socket) do
      state
    else
      reason -> {:hello_error, reason}
    end
  end

  def create_secure_connection(
        %State{socket: socket, req_id: req_id, seq_number: seq_number} = state
      ) do
    req_id = req_id + 1
    seq_number = seq_number + 1
    # client_private_key = X509.PrivateKey.new_rsa(2048)

    # key_usage =
    #   X509.Certificate.Extension.key_usage([
    #     :digitalSignature,
    #     :keyEncipherment,
    #     :nonRepudiation,
    #     :dataEncipherment,
    #     :keyCertSign
    #   ])

    # client_public_key =
    #   client_private_key
    #   |> X509.Certificate.self_signed("/C=US/CN=Helios", extensions: [key_usage: key_usage])
    #   |> X509.Certificate.to_der()

    # File.write!("/Users/kaleb/test_priv.pem", X509.PrivateKey.to_pem(client_private_key))
    # File.write!("/Users/kaleb/test_cert.der", client_public_key)

    client_private_key = File.read!("/Users/kaleb/test_priv.pem") |> X509.PrivateKey.from_pem!()
    client_public_key = File.read!("/Users/kaleb/test_cert.der")

    recv_cert =
      <<91, 229, 69, 166, 39, 184, 138, 223, 99, 7, 145, 115, 112, 16, 179, 96, 51, 244, 13, 236>>

    with secure_connection_request <-
           Services.OpenSecureChannel.encode_command(
             "http://opcfoundation.org/UA/SecurityPolicy#Basic256Sha256",
             seq_number,
             req_id,
             client_private_key,
             client_public_key,
             recv_cert
           ),
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
      %{
        state
        | sec_channel_id: sci,
          token_id: token_id,
          req_id: req_id,
          seq_number: seq_number,
          sender_cert: scert,
          recv_cert: rcert,
          session_expire_time:
            DateTime.utc_now() |> DateTime.add(revised_lifetime_in_ms, :millisecond)
      }
    else
      reason -> {:secure_connect_error, reason}
    end
  end

  def close_secure_connection(
        %State{
          url: url,
          socket: socket,
          req_id: req_id,
          seq_number: seq_number,
          sec_channel_id: sci,
          token_id: token_id
        } = state
      ) do
    req_id = req_id + 1
    seq_number = seq_number + 1

    request = Services.CloseSecureChannel.encode_command(token_id, sci, seq_number, req_id)
    :ok = :gen_tcp.send(socket, request)
    :ok = :gen_tcp.close(socket)
    reset_state(state)
  end

  def get_endpoints(
        %State{socket: socket, url: _url, req_id: req_id, seq_number: seq_number} = state
      ) do
    req_id = req_id + 1
    seq_number = seq_number + 1

    state = %{
      state
      | req_id: req_id,
        seq_number: seq_number
    }

    with endpoint_request <- Services.GetEndpoints.encode_command(state),
         :ok <- :gen_tcp.send(socket, endpoint_request),
         {:ok, %{payload: %{endpoints: response}}} <- Protocol.recieve_message(socket, req_id) do
      {state, response}
    else
      reason -> {:get_endpoint_error, reason}
    end
  end

  def create_session(
        %State{
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
           Services.CreateSession.encode_command(%{
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
      %{state | auth_token: auth_token, req_id: req_id, seq_number: seq_number}
    else
      reason -> {:session_error, reason}
    end
  end

  def activate_session(
        %State{
          socket: socket,
          auth_token: auth_token,
          sec_channel_id: sec_channel_id,
          req_id: req_id,
          seq_number: seq_number,
          token_id: token_id,
          url: _url
        } = state
      ) do
    next_sequence_num = seq_number + 1
    req_id = req_id + 1

    with session_request <-
           Services.ActivateSession.encode_command(%{
             sec_channel_id: sec_channel_id,
             token_id: token_id,
             auth_token: auth_token,
             req_id: req_id,
             seq_number: next_sequence_num
           }),
         :ok <- :gen_tcp.send(socket, session_request),
         {:ok, %{payload: %{activated: true}}} <- Protocol.recieve_message(socket) do
      IO.puts("Session Activated")
      %{state | req_id: req_id, seq_number: next_sequence_num}
    else
      reason -> {:activate_session_error, reason}
    end
  end

  def check_session(
        %State{
          seq_number: seq_number,
          session_expire_time: expire_time
        } = s
      ) do
    if DateTime.compare(DateTime.utc_now(), expire_time) == :lt do
      next_sequence_num = seq_number + 1
      %{s | seq_number: next_sequence_num}
    else
      s
      |> create_session()
      |> activate_session()
    end
  end

  def reset_state(%State{ip: ip, url: url, handler: handler, port: port}),
    do: %State{ip: ip, url: url, handler: handler, port: port}
end
