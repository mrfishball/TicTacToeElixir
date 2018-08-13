defmodule Cli do

  def output(message, type) do
    case type do
      :menu -> output(Colorizer.yellow(message))
      :status -> output(Colorizer.yellow(message))
      :error -> output(Colorizer.red(message))
    end
  end

  def output(message) do
    IO.puts message
  end

  def input(message, type) do
    case type do
      :request -> input(Colorizer.yellow(message))
    end
  end

  def input(message) do
    input = IO.gets message
    String.trim(input)
  end
end
