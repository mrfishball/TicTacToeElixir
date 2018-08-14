defmodule TTT.Console.IOTest do
  use ExUnit.Case
  import ExUnit.CaptureTTT.Console.IO

  test "adapter relays payload to output source" do
    payload = "This is a payload"
    assert capture_io(fn -> TTT.Console.IO.output(payload) end) == "This is a payload\n"
  end

  test "adapter relays requests to input source" do
    request = "How are you?"
    assert capture_io(" ", fn -> TTT.Console.IO.input(request) end) == "How are you?"
  end
end
