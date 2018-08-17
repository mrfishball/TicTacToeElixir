defmodule TTT.Utilities.InputValidators do

  @moduledoc """
    Perform user input validation.
  """

  @doc """

    ## Parameters

      -input: String of user input.

    Returns true if, after removing any trailing whitespaces, the input is empty.
  """
  def empty_input?(input) do
    input = String.trim(input)
    String.length(input) < 1
  end

  @doc """

    ## Parameters

      -input: String of user input.

    Returns true if, after removing any trailing whitespaces, the input is a
    string of digit from 1 to 9.
  """
  def valid_move?(input) do
    Regex.match?(~r/^[1-9]{1}$/, String.trim(input))
  end
end
