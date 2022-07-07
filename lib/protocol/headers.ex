defmodule ExOpcua.Protocol.Headers do
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.BuiltInDataTypes.OpcString

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

  @spec take(binary()) ::
          {%MSGHeader{} | %OpenSecureChannelHeader{} | %HelloHeader{}, binary() | <<>>}
          | {:error, atom()}
  def take(
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

  def take(
        <<"OPN"::binary, chunk_type::bytes-size(1), msg_size::int(32), sec_channel_id::int(32),
          rest::binary>>
      ) do
    with {policy_uri, rest} <- OpcString.take(rest),
         {sender_cert, rest} <- OpcString.take(rest),
         {recv_cert, rest} <- OpcString.take(rest) do
      {%OpenSecureChannelHeader{
         msg_size: msg_size,
         chunk_type: Map.get(@chunk_types, chunk_type),
         sec_channel_id: sec_channel_id,
         policy_uri: policy_uri,
         sender_cert: sender_cert,
         recv_cert: recv_cert
       }, rest}
    end
  end

  def take(
        <<"MSG"::binary, chunk_type::bytes-size(1), msg_size::int(32), sec_channel_id::int(32),
          sec_token_id::int(32), message::binary>>
      ) do
    {%MSGHeader{
       msg_size: msg_size,
       chunk_type: Map.get(@chunk_types, chunk_type),
       sec_channel_id: sec_channel_id,
       sec_token_id: sec_token_id
     }, message}
  end

  def take(
        <<"ERR"::binary, _chunk_type::bytes-size(1), _msg_size::int(32),
          error_type::bytes-size(4), deserialize_string(reason), _::binary>>
      ) do
    {%ErrHeader{error_type: error_type, reason: reason}, <<>>}
  end

  def take(output) do
    {:error, :invalid_header}
  end
end
