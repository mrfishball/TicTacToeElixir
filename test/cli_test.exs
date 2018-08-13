defmodule CliTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "menu message will be yellow" do
    {type, message} = {:menu, "this is a menu"}
    assert capture_io(fn -> Cli.output({type, message}) end) == "\e[33mthis is a menu\e[0m\n"
  end

  test "status message will be yellow" do
    {type, message} = {:status, "this is a status"}
    assert capture_io(fn -> Cli.output({type, message}) end) == "\e[33mthis is a status\e[0m\n"
  end

  test "error message will be red" do
    {type, message} = {:error, "this is an error"}
    assert capture_io(fn -> Cli.output({type, message}) end) == "\e[31mthis is an error\e[0m\n"
  end

  test "request message will be yellow" do
    {type, message} = {:request, "this is a request"}
    assert capture_io(fn -> Cli.input({type, message}) end) == "\e[33mthis is a request\e[0m"
  end

  test "message with no type field will be of default color" do
    payload = "this is just a message"
    assert capture_io(fn -> Cli.output(payload) end) == "this is just a message\n"
  end

  test "reuest with no type field will be of default color" do
    payload = "this is just a request"
    assert capture_io(fn -> Cli.input(payload) end) == "this is just a request"
  end
end
