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
      "\nChoose the type of the computer player for Computer 1 (Enter a number from 1 to 2)\n\n" <>
      "1. Naive - (Computer 1 will take the first available spot)\n" <>
      "2. Random - (Computer 1 will take an available spot randomly)\n"
  end

  test "when the game is a tie, the status string will indicate that it's a tie" do
    {_progress, outcome} = {:ended, :draw}
    assert Messages.game_status(outcome) == "Game over!\nIt's a draw!"
  end

  test "when the ended with a winner, the status string will indictate the result and the winner's name" do
    {_progress, {outcome, winner}} = {:ended, {:winner, "Connie"}}
    assert Messages.game_status(outcome, winner) == "Game over!\nThe winner is Connie!"
  end

  test "when asking for an input for a move, user's token is stripped of whitespaces before outputting" do
    assert Messages.make_a_move("Steven", "  X  ") == "Steven - 'X', please enter a number from 1 to 9 only: "
  end

  test "cell taken error is outputted with the correct format" do
    {_status, error} = {:error, :cell_taken}
    assert Messages.invalid_move(error) == "\nInvalid move: cell_taken. Please try again. \n"
  end
end
