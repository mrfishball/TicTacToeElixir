defmodule CLIdisplay do

  def output({type, message} = _payload) do
    case type do
      :menu -> output(Colorizer.yellow(message))
      :status -> output(Colorizer.yellow(message))
      :error -> output(Colorizer.red(message))
    end
  end

  def output(payload) do
    IO.puts "#{payload}"
  end

  def input({type, message} = _payload) do
    case type do
      :request -> input(Colorizer.yellow(message))
    end
  end

  def input(payload) do
    input = IO.gets payload
    input
  end
end
