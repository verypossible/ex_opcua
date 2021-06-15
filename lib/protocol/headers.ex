defmodule ExOpcua.Protocol.Headers do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros

  defmodule HelloHeader do
    defstruct [
      :msg_size,
      :chunk_type,
      :recieve_buffer_size,
      :send_buffer_size,
      :max_msg_size,
      :max_chunk_count,
      :url
    ]
  end

  defmodule OpenSecureChannelHeader do
    defstruct [
      :msg_size,
      :chunk_type,
      :sec_channel_id,
      :sec_token_id,
      :policy_uri,
      :seq_number,
      :req_id,
      sender_cert: <<0xFF, 0xFF, 0xFF, 0xFF>>,
      recv_cert: <<0xFF, 0xFF, 0xFF, 0xFF>>
    ]
  end

  defmodule MSGHeader do
    defstruct [
      :msg_size,
      :chunk_type,
      :sec_channel_id,
      :policy_uri,
      :seq_number,
      :sec_token_id,
      :req_id,
      sender_cert: <<0xFF, 0xFF, 0xFF, 0xFF>>,
      recv_cert: <<0xFF, 0xFF, 0xFF, 0xFF>>
    ]
  end

  defmodule ErrHeader do
    defstruct [:error_type, :reason]
  end

  @chunk_types %{
    "C" => :intermediate,
    "F" => :final,
    "A" => :final_aborted
  }

  @spec decode_message_header(binary()) ::
          {%MSGHeader{} | %OpenSecureChannelHeader{} | %HelloHeader{}, binary() | <<>>}
          | {:error, atom()}
  def decode_message_header(
        <<"ACK"::binary, chunk_type::bytes-size(1), msg_size::int(32), _version::int(32),
          rec_buffer_size::int(32), send_buffer_size::int(32), max_msg_size::int(32),
          max_chunk_count::int(32), message::binary>>
      ) do
    {%HelloHeader{
       msg_size: msg_size,
       chunk_type: Map.get(@chunk_types, chunk_type),
       recieve_buffer_size: rec_buffer_size,
       send_buffer_size: send_buffer_size,
       max_msg_size: max_msg_size,
       max_chunk_count: max_chunk_count
     }, message}
  end

  def decode_message_header(
        <<"OPN"::binary, chunk_type::bytes-size(1), msg_size::int(32), sec_channel_id::int(32),
          policy_uri_size::int(32), policy_uri::bytes-size(policy_uri_size),
          sender_cert::bytes-size(4), recv_cert::bytes-size(4), sec_seq_number::integer-size(32),
          sec_req_id::little-unsigned-integer-size(32), message::binary>>
      ) do
    {%OpenSecureChannelHeader{
       msg_size: msg_size,
       chunk_type: Map.get(@chunk_types, chunk_type),
       sec_channel_id: sec_channel_id,
       policy_uri: policy_uri,
       seq_number: sec_seq_number,
       req_id: sec_req_id,
       sender_cert: sender_cert,
       recv_cert: recv_cert
     }, message}
  end

  def decode_message_header(
        <<"MSG"::binary, chunk_type::bytes-size(1), msg_size::int(32), sec_channel_id::int(32),
          sec_token_id::int(32), sec_seq_number::little-unsigned-integer-size(32),
          sec_req_id::little-unsigned-integer-size(32), message::binary>>
      ) do
    {%MSGHeader{
       msg_size: msg_size,
       chunk_type: Map.get(@chunk_types, chunk_type),
       sec_channel_id: sec_channel_id,
       seq_number: sec_seq_number,
       sec_token_id: sec_token_id,
       req_id: sec_req_id
     }, message}
  end

  def decode_message_header(
        <<"ERR"::binary, _chunk_type::bytes-size(1), _msg_size::int(32),
          error_type::bytes-size(4), reason::binary>>
      ) do
    {%ErrHeader{error_type: error_type, reason: reason}, <<>>}
  end

  def decode_message_header(output) do
    IO.inspect(Base.encode16(output))
    {:error, :invalid_header}
  end
end
