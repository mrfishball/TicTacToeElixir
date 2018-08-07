defmodule AdapterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "adapter relays payload to output source" do
    payload = "This is a payload"
    assert Adapter.output(payload) == :ok
  end

  test "adapter relays requests to input source" do
    request = "How are you?"
    assert Adapter.input(request) == :ok
  end
end
