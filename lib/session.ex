defmodule ExOpcua.Session do
  alias ExOpcua.Protocol.Headers
  alias ExOpcua.{Protocol, SecurityProfile, Services}
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
      :security_profile,
      req_id: 0,
      seq_number: 0,
      sec_channel_id: 0,
      session_signature: nil
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
    url = opts[:url] || "opc.tcp://#{ip}:#{port}"

    handler = opts[:handler] || ExOpcua.Session.Handler
    %SecurityProfile{} = sec_profile = opts[:security_profile] || %SecurityProfile{}

    # initial values
    state = %State{
      handler: handler,
      security_profile: sec_profile,
      ip: ip,
      port: port,
      url: url
    }

    GenServer.start_link(__MODULE__.Server, state, [])
  end

  def initiate_hello(%State{socket: socket, url: url} = state) do
    with hello_message <- Protocol.encode_hello_message(url),
         :ok <- :gen_tcp.send(socket, hello_message),
         {:ok, %{header: %Headers.HelloHeader{}}} <-
           Protocol.recieve_message(state) do
      state
    else
      reason -> {:hello_error, reason}
    end
  end

  def create_secure_connection(
        %State{
          socket: socket,
          security_profile: sec_profile
        } = state
      ) do
    with secure_conn_request <- Services.OpenSecureChannel.encode_command(sec_profile),
         {state, secure_conn_request} <-
           Protocol.build_asymetric_packet(secure_conn_request, state),
         :ok <- :gen_tcp.send(socket, secure_conn_request),
         {:ok,
          %{
            header: %Headers.OpenSecureChannelHeader{},
            payload: %{
              sec_channel_id: sci,
              token_id: token_id,
              revised_lifetime_in_ms: revised_lifetime_in_ms,
              server_nonce: server_nonce
            }
          }} <- Protocol.recieve_message(state),
         sec_profile = SecurityProfile.derive_sym_keys(sec_profile, server_nonce) do
      %{
        state
        | security_profile: sec_profile,
          sec_channel_id: sci,
          token_id: token_id,
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

  def create_session(%State{socket: sock} = state) do
    with session_request <-
           Services.CreateSession.encode_command(state),
         {state, session_request} <-
           Protocol.build_symetric_packet(session_request, state),
         :ok <- :gen_tcp.send(sock, session_request),
         {:ok,
          %{
            payload:
              %{
                session_id: _session_id,
                auth_token: auth_token,
                server_session_signature: session_signature,
                revised_session_timeout: _revised_session_timeout
              } = output
          }} <- Protocol.recieve_message(state) do
      client_signature = SecurityProfile.sign(session_signature, state.security_profile)
      %{state | auth_token: auth_token, session_signature: client_signature}
    else
      reason -> {:session_error, reason}
    end
  end

  def activate_session(%State{socket: socket} = state) do
    with session_request <-
           Services.ActivateSession.encode_command(state),
         {state, session_request} <-
           Protocol.build_symetric_packet(session_request, state),
         :ok <- :gen_tcp.send(socket, session_request),
         {:ok, %{payload: %{activated: true}} = full} <- Protocol.recieve_message(state, :debug) do
      IO.inspect(full, limit: :infinity)
      state
    else
      reason -> {:activate_session_error, reason}
    end
  end

  def check_session(
        %State{
          session_expire_time: expire_time
        } = s
      ) do
    if DateTime.compare(DateTime.utc_now(), expire_time) == :lt do
      s
    else
      s
      |> create_session()
      |> activate_session()
    end
  end

  def reset_state(%State{ip: ip, url: url, handler: handler, port: port}),
    do: %State{ip: ip, url: url, handler: handler, port: port}
end
