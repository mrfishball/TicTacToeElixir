defmodule ColorizerTest do
  use ExUnit.Case

  test "item has been encoding to be yellow in CLI" do
    item = "This is yellow."
    assert Colorizer.yellow(item) == IO.ANSI.yellow <> "This is yellow." <> IO.ANSI.reset
  end

  test "item has been encoding to be red in CLI" do
    item = "This is red."
    assert Colorizer.red(item) == IO.ANSI.red <> "This is red." <> IO.ANSI.reset
  end

  test "item has been encoding to be cyan in CLI" do
    item = "This is cyan."
    assert Colorizer.cyan(item) == IO.ANSI.cyan <> "This is cyan." <> IO.ANSI.reset
  end

  test "item has been encoding to be green in CLI" do
    item = "This is green."
    assert Colorizer.green(item) == IO.ANSI.green <> "This is green." <> IO.ANSI.reset
  end
end
