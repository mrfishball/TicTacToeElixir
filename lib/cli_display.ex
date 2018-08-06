defmodule CLIdisplay do

  def output(payload) do
    IO.puts "#{payload}"
  end

  def input(message) do
    input = IO.gets "#{message}"
    input
  end
end
