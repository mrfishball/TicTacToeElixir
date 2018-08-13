defmodule IOBuilder do

  def input(payload, type, source \\ &Cli.input/2) do
    source.(payload, type)
  end

  # def input(payload, source \\ &Cli.input/1) do
  #   source.(payload)
  # end
  #
  # def output(payload, source \\ &Cli.output/1) do
  #   source.(payload)
  # end

  def output(payload, type, source \\ &Cli.output/2) do
    source.(payload, type)
  end
end
