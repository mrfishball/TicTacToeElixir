defmodule TTT.Console.Colorizer do

  @moduledoc """
    Add color to a string for display in command line.
  """

  @doc """

    ## Parameters

      - item: String of message.

    Returns a string with color encoding for display in command line.
    ANSI.reset at the end of string is to remove any color effects for
    any strings displayed afterward.
  """

  def yellow(item) do
    IO.ANSI.yellow <> item <> IO.ANSI.reset
  end

  def red(item) do
    IO.ANSI.red <> item <> IO.ANSI.reset
  end

  def cyan(item) do
    IO.ANSI.cyan <> item <> IO.ANSI.reset
  end

  def green(item) do
    IO.ANSI.green <> item <> IO.ANSI.reset
  end
end
