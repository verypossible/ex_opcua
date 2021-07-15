defmodule ExOpcua do
  @moduledoc """
  Documentation for `ExOpcua`.
  """

  @doc """
  Library functions for OPC UA Lib.
  """
  alias ExOpcua.Session
  alias ExOpcua.Services.Read
  alias ExOpcua.DataTypes.NodeId

  def start_link(opts \\ []) do
    Session.start_link(opts)
  end

  def send(pid) do
    GenServer.cast(pid, :send)
  end

  def read(pid) do
    GenServer.call(pid, :read)
  end

  def read_all_attrs(node_id, pid) do
    # 1..27 come back in order
    # https://reference.opcfoundation.org/v104/Core/docs/Part6/A.1/
    GenServer.call(pid, {:read_all, node_id})

    # chunk_every
    # enum with index
    # get class by index # 0 = NodeId
    # that determines name key
  end

  def read_values(node_ids, pid, format \\ :pretty)

  def read_values([node | _rest] = nodeids, pid, format) when is_binary(node) do
    nodeids
    |> Enum.map(&NodeId.parse/1)
    |> read_values(pid, format)
  end

  def read_values(node_ids, pid, format) when is_list(node_ids) do
    GenServer.call(pid, {:read_values, node_ids})
    |> Read.format_output(node_ids, format)
  end

  def read_values(node_id, pid, format) do
    read_values([node_id], pid, format)
    |> Read.format_output([node_id], format)
  end
end
