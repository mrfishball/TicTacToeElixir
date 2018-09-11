defmodule CliTest do
  alias TTT.Message.MessageTags
  alias TTT.Console.Cli, as: Cli
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "menu type message will be yellow" do
    type = MessageTags.menu()
    message = "this is a menu"
    assert capture_io(fn -> Cli.output(message, type) end) == "\e[33mthis is a menu\e[0m\n"
  end

  test "status message will be yellow" do
    type = MessageTags.status()
    message = "this is a status"
    assert capture_io(fn -> Cli.output(message, type) end) == "\e[33mthis is a status\e[0m\n"
  end

  test "error message will be red" do
    type = MessageTags.error()
    message = "this is an error"
    assert capture_io(fn -> Cli.output(message, type) end) == "\e[31mthis is an error\e[0m\n"
  end

  test "request message will be yellow" do
    type = MessageTags.request()
    message = "this is a request"
    assert capture_io(" ", fn -> Cli.input(message, type) end) == "\e[33mthis is a request\e[0m"
  end

  test "message with no type field will be of default color" do
    payload = "this is just a message"
    assert capture_io(fn -> Cli.output(payload) end) == "this is just a message\n"
  end

  test "request with no type field will be of default color" do
    payload = "this is just a request"
    assert capture_io(" ", fn -> Cli.input(payload) end) == "this is just a request"
  end
end
