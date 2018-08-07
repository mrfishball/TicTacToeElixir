defmodule MessagesTest do
  use ExUnit.Case

  test "when asking for a name, output string will indicator player numbers" do
    assert Messages.player_name(1) == "What is your name? (Player 1): "
  end

  test "when asking for a symbol, output string will show player's name" do
    assert Messages.player_symbol("Steven") == "What do you want your token to be, Steven?: "
  end

  test "when asking for a computer type, output will show computer player's name" do
    assert Messages.computer_choice_menu("Computer 1") ==
      "Choose the type of the computer player for Computer 1 (Enter a number from 1 to 2)\n1. Naive - (Computer 1 will take the first available spot)\n2. Random - (Computer 1 will take an available spot randomly)\n\n"
  end
end
