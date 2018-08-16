defmodule ValidatorsTest do
  alias TTT.Utilities.Validators, as: Validators
  use ExUnit.Case

  test "string with whitespace will be consider an empty string" do
    assert Validators.empty_input?(" ") == true
  end

  test "a string with trailing whitespaces will not be consider an empty string" do
    assert Validators.empty_input?(" Steven  ") == false
  end
end
