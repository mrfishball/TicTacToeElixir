defmodule Colorizer do

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
