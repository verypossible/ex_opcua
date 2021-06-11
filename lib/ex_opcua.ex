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

  def test_function do
    IO.puts("WOWZA")
  end

  defmacro test_macro do
    quote do

    end
  end
end
