defmodule InfoRelayAdapter do

  def input(payload, source \\ &CLIdisplay.input/1) do
    source.(payload)
  end

  def output(payload, source \\ &CLIdisplay.output/1) do
    source.(payload)
  end
end
