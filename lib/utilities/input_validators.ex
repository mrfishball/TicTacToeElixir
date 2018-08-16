defmodule TTT.Utilities.InputValidators do

  def empty_input?(input) do
    input = String.trim(input)
    String.length(input) < 1
  end

  def valid_move?(input) do
    Regex.match?(~r/^[1-9]{1}$/, String.trim(input))
  end
end
