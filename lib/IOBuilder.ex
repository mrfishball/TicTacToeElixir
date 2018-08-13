defmodule IOBuilder do

  def input(payload, type \\ None, source \\ &Cli.input/2) do
    source.(payload, type)
  end

  def output(payload, type \\ None, source \\ &Cli.output/2) do
    source.(payload, type)
  end
end
