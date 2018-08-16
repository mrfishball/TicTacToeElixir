defmodule IOcontroller do
  alias TTT.Console.Cli, as: Cli

  def input(payload, type \\ None, source \\ &Cli.input/2) do
    source.(payload, type)
  end

  def output(payload, type \\ None, source \\ &Cli.output/2) do
    source.(payload, type)
  end
end
