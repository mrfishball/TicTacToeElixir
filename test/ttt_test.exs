defmodule TTTTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest TTT

  test "Game will automatically switch turn to 'o' after 'x' has played and vice versa." do
    first_player = :x
    assert TTT.switch_turn(first_player) == :o

    first_player = :o
    assert TTT.switch_turn(first_player) == :x
  end

  test "Only a string of '1' to '9' will be accepted as valid input." do
    input1 = "1"
    input2 = " "
    input3 = "aa"
    input4 = ",,"
    input5 = "10"
    input6 = "0"
    input7 = "5"
    assert TTT.valid_input?(input1) == :true
    assert TTT.valid_input?(input2) == :false
    assert TTT.valid_input?(input3) == :false
    assert TTT.valid_input?(input4) == :false
    assert TTT.valid_input?(input5) == :false
    assert TTT.valid_input?(input6) == :false
    assert TTT.valid_input?(input7) == :true
  end

  test "Valid user input will be map to the correct coordinate on the board" do
    TTT.match_input("1") == {0, 0}
    TTT.match_input("9") == {2, 2}
    TTT.match_input("5") == {1, 1}
  end

  test "Visual board is updated accordingly" do
    turn = :o
    board = Board.new
    game = Game.new
    {:ok, game} = Game.play_turn(game, :o, {0, 0})
    {:ok, game} = Game.play_turn(game, :x, {2, 1})
    {:ok, game} = Game.play_turn(game, :o, {1, 0})
    {:ok, game} = Game.play_turn(game, :x, {1, 1})
    {:ok, game} = Game.play_turn(game, :o, {2, 0})

    assert capture_io(fn -> TTT.update_visual(board, game, turn) end) ==
      "\n\n O | O | O\n---+---+---\n   | X | X\n---+---+---\n   |   |  \n\n\n"
  end
end
