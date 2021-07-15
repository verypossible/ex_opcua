defmodule ExOpcuaTest do
  use ExUnit.Case
  doctest ExOpcua

  # Integration Test,enable for local testing until we can integration test
  # test "read formatting" do
  #   opts = [ip: "Daniels-MacBook-Pro.local", port: 53530]
  #   {:ok, pid} = ExOpcua.start_link(opts)
  #   res = ExOpcua.read_values(["ns=3;i=1001"], pid, :pretty)
  #   IO.inspect(res)
  # end
end
