defmodule ExOpcua.Protocol.HelloHeader do
  defstruct [
    :msg_size,
    :recieve_buffer_size,
    :send_buffer_size,
    :max_msg_size,
    :max_chunk_count,
    :url
  ]
end

defmodule ExOpcua.Protocol.OpenSecureChannelHeader do
  defstruct [
    :msg_size,
    :sec_channel_id,
    :sec_token_id,
    :policy_uri,
    :seq_number,
    :req_id,
    sender_cert: <<0xFF, 0xFF, 0xFF, 0xFF>>,
    recv_cert: <<0xFF, 0xFF, 0xFF, 0xFF>>
  ]
end

defmodule ExOpcua.Protocol.MSGHeader do
  defstruct [
    :msg_size,
    :sec_channel_id,
    :policy_uri,
    :seq_number,
    :sec_token_id,
    :req_id,
    sender_cert: <<0xFF, 0xFF, 0xFF, 0xFF>>,
    recv_cert: <<0xFF, 0xFF, 0xFF, 0xFF>>
  ]
end

defmodule ExOpcua.Protocol.ErrHeader do
  defstruct [:error_type, :reason]
end

defmodule ExOpcua.Protocol.Headers do
  alias ExOpcua.Protocol.{HelloHeader, OpenSecureChannelHeader, MSGHeader, ErrHeader}

  @spec decode_message_header(atom(), binary()) ::
          {%MSGHeader{} | %OpenSecureChannelHeader{} | %HelloHeader{}, binary() | <<>>}
          | {:error, atom()}
  def decode_message_header(
        :ack,
        <<_chunk_type::bytes-size(1), msg_size::little-integer-size(32),
          _version::little-integer-size(32), rec_buffer_size::little-integer-size(32),
          send_buffer_size::little-integer-size(32), max_msg_size::little-integer-size(32),
          max_chunk_count::little-integer-size(32), message::binary>>
      ) do
    {%HelloHeader{
       msg_size: msg_size,
       recieve_buffer_size: rec_buffer_size,
       send_buffer_size: send_buffer_size,
       max_msg_size: max_msg_size,
       max_chunk_count: max_chunk_count
     }, message}
  end

  def decode_message_header(
        :open_secure_channel,
        <<_chunk_type::bytes-size(1), msg_size::little-integer-size(32),
          sec_channel_id::little-integer-size(32), policy_uri_size::little-integer-size(32),
          policy_uri::bytes-size(policy_uri_size), sender_cert::bytes-size(4),
          recv_cert::bytes-size(4), sec_seq_number::integer-size(32),
          sec_req_id::integer-size(32), message::binary>>
      ) do
    {%OpenSecureChannelHeader{
       msg_size: msg_size,
       sec_channel_id: sec_channel_id,
       policy_uri: policy_uri,
       seq_number: sec_seq_number,
       req_id: sec_req_id,
       sender_cert: sender_cert,
       recv_cert: recv_cert
     }, message}
  end

  def decode_message_header(
        :message,
        <<_chunk_type::bytes-size(1), msg_size::little-integer-size(32),
          sec_channel_id::little-integer-size(32), sec_token_id::little-integer-size(32),
          sec_seq_number::integer-size(32), sec_req_id::integer-size(32), message::binary>>
      ) do
    {%MSGHeader{
       msg_size: msg_size,
       sec_channel_id: sec_channel_id,
       seq_number: sec_seq_number,
       sec_token_id: sec_token_id,
       req_id: sec_req_id
     }, message}
  end

  def decode_message_header(
        :error_msg,
        <<_chunk_type::bytes-size(1), _msg_size::little-integer-size(4),
          error_type::bytes-size(4), reason::binary>>
      ) do
    IO.puts(inspect(%ErrHeader{error_type: error_type, reason: reason}))
    {%ErrHeader{error_type: error_type, reason: reason}, <<>>}
  end

  def decode_message_header(_, thing) do
    {:error, :invalid_header}
  end
end
