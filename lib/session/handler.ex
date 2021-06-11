defmodule ExOpcua.Session.Handler do
  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour ExOpcua.Session.Handler

      @impl true
      def handle_payload(decoded_payload) do
        IO.puts(inspect(decoded_payload))
        :ok
      end

      defoverridable ExOpcua.Session.Handler
    end
  end

  @doc """
  Invoked when an OPC connection recieves a message on the line
  Handler should act on output and respond with :ok
  Any other response is met with restart of the connection.
  """
  @callback handle_payload(decoded_payload :: struct()) :: :ok
  def handle_payload(decoded_payload) do
    IO.puts(inspect(decoded_payload))
    :ok
  end
end
