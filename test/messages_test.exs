defmodule MessagesTest do
  use ExUnit.Case

  test "when asking for a symbol, output message will show player's name" do
    message = Messages.player_symbol("Steven")
    assert message == "What do you want your token to be, Steven?: "
  end

  test "when asking for a name, output message will indicator player numbers" do
    message = Messages.player_name(1)
    assert message == "What is your name? (Player 1): "
  end

  test "when asking for a computer type, output message will show computer player's name" do
    message = Messages.computer_choice_menu("Computer 1")
    assert message ==
      "\nChoose the type of the computer player for Computer 1 (Enter a number from 1 to 2)\n\n" <>
      "1. Naive - (Computer 1 will take the first available spot)\n" <>
      "2. Random - (Computer 1 will take an available spot randomly)\n"
  end

  test "the output message for when the game ended in a draw will indicate that it's a draw" do
    {_progress, outcome} = {:ended, :draw}
    message = Messages.game_status(outcome)
    assert message == "Game over!\nIt's a draw!"
  end

  test "the output message for when the game ended with a win will include the winner's name" do
    {_progress, {outcome, winner}} = {:ended, {:winner, "Connie"}}
    message = Messages.game_status(outcome, winner)
    assert message == "Game over!\nThe winner is Connie!"
  end

  test "when asking for an input for a move, user's token is stripped of whitespaces before outputting" do
    message = Messages.make_a_move("Steven", "   X ")
    assert message == "Steven - 'X', please enter a number from 1 to 9 only: "
  end

  test "cell taken error message is outputted with correspondingly" do
    {_status, error} = {:error, :cell_taken}
    message = Messages.invalid_move(error)
    assert message == "\nInvalid move: cell_taken. Please try again. \n"
  end
end
