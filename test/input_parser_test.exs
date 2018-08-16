defmodule InputParserTest do
  alias TTT.Utilities.InputParser, as: InputParser
  use ExUnit.Case

  test "Valid user input will be map to the correct coordinate on the board" do
    assert InputParser.parse_input(1) == {0, 0}
    assert InputParser.parse_input(9) == {2, 2}
    assert InputParser.parse_input(5) == {1, 1}
  end
end
