defmodule ExOpcua do
  @moduledoc """
  Documentation for `ExOpcua`.
  """

  @doc """
  Library functions for OPC UA Lib.

  ## Examples

      iex> ExOpcua.open_session()
      {:ok, #PID<0,0,0>}

  """
  alias ExOpcua.Session

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
    GenServer.call(pid, {:read_all, node_id})
  end
end
