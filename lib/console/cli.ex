defmodule TTT.Console.Cli do
  alias TTT.Console.Colorizer, as: Colorizer

  @moduledoc """
    A command line module that is repsonsible for outputing messages
    as well as receiving inputs from users
  """

  @doc """

    ## Parameters

      - message: String of message.
      _ type (optional): String represents the type of the message

    Display a string with effects correspond on the type of the message.
    If type is not given or does not match, message will be displayed without any effects.
  """
  def output(message, type \\ None) do
    case type do
      "menu" -> IO.puts(Colorizer.yellow(message))
      "title" -> IO.puts(Colorizer.yellow(message))
      "status" -> IO.puts(Colorizer.yellow(message))
      "error" -> IO.puts(Colorizer.red(message))
      None -> IO.puts(message)
    end
  end

  @doc """

    ## Parameters

      - message: String of message.
      _ type (optional): String represents the type of the message

    Display a string with effects correspond on the type of the message.
    If type is not given or does not match, message will be displayed without any effects.

    Returns a string without any whilespaces around.
  """
  def input(message, type \\ None) do
    case type do
      "request" ->
        input = IO.gets(Colorizer.yellow(message))
        String.trim(input)
      None ->
        input = IO.gets(message)
        String.trim(input)
    end
  end
end
