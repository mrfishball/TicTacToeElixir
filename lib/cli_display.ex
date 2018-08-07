defmodule CLIdisplay do

  def output({type, message} = _payload) do
    case type do
      :menu -> IO.puts Colorizer.yellow(message)
      :error -> IO.puts Colorizer.red(message)
      :status -> IO.puts message
      :request -> IO.puts message
    end
  end

  def output(payload) do
    IO.puts "#{payload}"
  end

  def input({_type, message} = _payload) do
    input = IO.gets message
    input
  end
end
