defmodule InputOutput do

  def input(payload, source \\ &Cli.input/1) do
    source.(payload)
  end

  def output(payload, source \\ &Cli.output/1) do
    source.(payload)
  end
end
