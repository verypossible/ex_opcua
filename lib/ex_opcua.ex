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

  @spec read_all_attrs(List.t(), pid(), Atom.t()) :: map()
  def read_all_attrs(node_ids, pid, format \\ :pretty)

  def read_all_attrs([node | _rest] = nodeids, pid, format) when is_binary(node) do
    nodeids
    |> Enum.map(&NodeId.parse/1)
    |> read_all_attrs(pid, format)
  end

  def read_all_attrs(node_ids, pid, format) when is_list(node_ids) do
    # 1..27 come back in order
    # https://reference.opcfoundation.org/v104/Core/docs/Part6/A.1/
    GenServer.call(pid, {:read_all, node_ids})
    |> Read.format_output(node_ids, Read.attribute_ids(), format)
  end

  def read_all_attrs(node_id, pid, format) do
    read_all_attrs([node_id], pid, format)
    |> Read.format_output([node_id], Read.attribute_ids(), format)
  end

  @spec read_attrs(List.t(), pid(), list(Atom.t()), Atom.t()) :: map()
  def read_attrs(node_ids, pid, attrs \\ [:browse_name, :value], format \\ :pretty)

  def read_attrs([node | _rest] = nodeids, pid, attrs, format) when is_binary(node) do
    nodeids
    |> Enum.map(&NodeId.parse/1)
    |> read_attrs(pid, attrs, format)
  end

  def read_attrs(node_ids, pid, attrs, format) when is_list(node_ids) do
    GenServer.call(pid, {:read_attrs, node_ids, attrs})
    |> Read.format_output(node_ids, attrs, format)
  end

  def read_attrs(node_id, pid, attrs, format) do
    read_attrs([node_id], pid, attrs, format)
  end
end
