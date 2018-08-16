defmodule TTT.Utilities.Validators do

  def empty_input?(input) do
    input = String.trim(input)
    String.length(input) < 1
  end
end
