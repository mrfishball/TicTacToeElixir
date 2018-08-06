defmodule Adapter do

  def input(payload, medium \\ &CLIdisplay.input/1) do
    medium.(payload)
  end

  def output(payload, medium \\ &CLIdisplay.output/1) do
    medium.(payload)
  end
end
