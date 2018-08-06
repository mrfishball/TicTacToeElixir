defmodule CLIdisplayTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "output a message in command line" do
    assert capture_io(fn -> CLIdisplay.output("testing") end) == "testing\n"
  end
end
