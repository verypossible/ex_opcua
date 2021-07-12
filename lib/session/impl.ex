defmodule ExOpcua.Session.Impl do
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
      :session_expire_time,
      :auth_token,
      req_id: 0,
      seq_number: 0
    ]
  end

  @moduledoc """
  	Contains all the non-genserver implementation for ExOpcua Sessions
  """
  def initiate_hello(%State{socket: socket, url: url} = state) do
    with hello_message <- Protocol.encode_message(:hello, %{url: url}),
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
           Protocol.encode_message(:activate_session, %{
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
end
