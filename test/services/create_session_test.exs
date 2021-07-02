# defmodule ExOpcua.Services.CreateSessionTest do
#   use ExUnit.Case

#   alias ExOpcua.Services.CreateSession

#   def test_response do
#     <<0x02>> <> <<22::little-integer-size(16)>> <> <<4444::little-integer-size(32)>> <> "rest"
#   end

#   test "decode_response/1 does something" do
#     res = test_response()
#     IO.inspect(res)
#     assert CreateSession.decode_response(res) == :world
#   end
# end
