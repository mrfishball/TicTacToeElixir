defmodule InputValidatorsTest do
  alias TTT.Utilities.InputValidators, as: InputValidators
  use ExUnit.Case

  test "string with whitespace will be consider an empty string" do
    assert InputValidators.empty_input?(" ") == true
  end

  test "a string with trailing whitespaces will not be consider an empty string" do
    assert InputValidators.empty_input?(" Steven  ") == false
  end

  test "A number '1' through '9' will be a valid input" do
    inputs = ["1", "2", "5", "8", "9"]
    for input <- inputs, do: assert InputValidators.valid_move?(input) == true
  end

  test "Whitespaces before a valid input will be ignored, such input will be a valid one" do
    inputs = ["  3", "    7", " 4"]
    for input <- inputs, do: assert InputValidators.valid_move?(input) == true
  end

  test "Whitespaces after a valid input will be ignored, such input will be a valid one" do
    inputs = ["1  ", "2    ", "8 "]
    for input <- inputs, do: assert InputValidators.valid_move?(input) == true
  end

  test "Newlines after a valid input will be ignored, such input will be a valid one" do
    inputs = ["2\n\n", "6\n"]
    for input <- inputs, do: assert InputValidators.valid_move?(input) == true
  end

  test "Newlines before a valid input will be ignored, such input will be a valid one" do
    inputs = ["\n\n7", "\n3"]
    for input <- inputs, do: assert InputValidators.valid_move?(input) == true
  end

  test "A number smaller than '1' will be invalidated" do
    invalids = ["-1", "-23", "0"]
    for input <- invalids, do: assert InputValidators.valid_move?(input) == false
  end

  test "A number greater than '9' will be invalidated" do
    invalids = ["10", "50", "120"]
    for input <- invalids, do: assert InputValidators.valid_move?(input) == false
  end

  test "Symbols will be invalidated" do
    symbols = ["`", "~", "@", "#", "$"]
    for symbol <- symbols, do: assert InputValidators.valid_move?(symbol) == false
  end

  test "Letters will be invalidated" do
    letters = ["a", "z", "G", "T"]
    for letter <- letters, do: assert InputValidators.valid_move?(letter) == false
  end

  test "Empty input, whitespaces and newlines will be invalidated" do
    inputs = ["", " ", "   ", "\n", "\n\n\n"]
    for input <- inputs, do: assert InputValidators.valid_move?(input) == false
  end

  test "Other characters will be invalidated" do
    inputs = ["哈", "ト", "قلب", "হৃদয়", "หัวใจ"]
    for input <- inputs, do: assert InputValidators.valid_move?(input) == false
  end
end
