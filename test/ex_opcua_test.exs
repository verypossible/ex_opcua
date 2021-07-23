defmodule ExOpcuaTest do
  use ExUnit.Case
  doctest ExOpcua
  alias ExOpcua.Services.Read

  @to_read [
    "ns=3;i=1001",
    "ns=3;i=1002",
    "ns=3;i=1003",
    "ns=3;i=1004",
    "ns=3;i=1005"
  ]

  # Integration Test, enable for local testing until we can integration test
  @moduletag :integration

  test "read formatting defaults to pretty uses browse name and value" do
    opts = [ip: "Daniels-MacBook-Pro.local", port: 53530]
    {:ok, pid} = ExOpcua.start_link(opts)

    res = ExOpcua.read_attrs(@to_read, pid)
    assert length(Map.keys(res)) == length(@to_read)
  end

  test "read formatting defaults to pretty, shows attrs" do
    opts = [ip: "Daniels-MacBook-Pro.local", port: 53530]
    {:ok, pid} = ExOpcua.start_link(opts)
    attrs = [:browse_name, :display_name, :value]
    res = ExOpcua.read_attrs(@to_read, pid, attrs)
    assert length(Map.keys(res)) == length(@to_read)
  end

  test "read formatting raw" do
    opts = [ip: "Daniels-MacBook-Pro.local", port: 53530]
    {:ok, pid} = ExOpcua.start_link(opts)

    attrs = [:browse_name, :display_name, :value]
    res = ExOpcua.read_attrs(@to_read, pid, attrs, :raw)
    # Raw has results in `read_results` entry
    assert length(res.read_results) == length(attrs) * length(@to_read)
  end

  test "read all defaults to pretty format, all attributes returned" do
    opts = [ip: "Daniels-MacBook-Pro.local", port: 53530]
    {:ok, pid} = ExOpcua.start_link(opts)
    res = ExOpcua.read_all_attrs(@to_read, pid)
    assert length(Map.keys(res)) == 5
    node_1 = List.first(@to_read)
    assert length(Map.keys(res[node_1])) == 27
  end

  test "read all raw results" do
    opts = [ip: "Daniels-MacBook-Pro.local", port: 53530]
    {:ok, pid} = ExOpcua.start_link(opts)
    res = ExOpcua.read_all_attrs(@to_read, pid, :raw)
    # Raw has a result for every known attribute, for every node
    assert length(res.read_results) == length(Read.attribute_ids()) * length(@to_read)
  end
end
