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
    input7 = "9"
    input8 = "@@@"
    input9 = "哈"
    input10 = "-1"
    input11 = "   1   "
    input12 = "\#{1+1}"
    input13 = "6666666666666666666666666"
    input14 = "\n"

    assert TTT.valid_input?(input1) == :true
    assert TTT.valid_input?(input2) == :false
    assert TTT.valid_input?(input3) == :false
    assert TTT.valid_input?(input4) == :false
    assert TTT.valid_input?(input5) == :false
    assert TTT.valid_input?(input6) == :false
    assert TTT.valid_input?(input7) == :true
    assert TTT.valid_input?(input8) == :false
    assert TTT.valid_input?(input9) == :false
    assert TTT.valid_input?(input10) == :false
    assert TTT.valid_input?(input11) == :true
    assert TTT.valid_input?(input12) == :false
    assert TTT.valid_input?(input13) == :false
    assert TTT.valid_input?(input14) == :false
  end

  test "Valid user input will be map to the correct coordinate on the board" do
    assert TTT.match_input("1") == {0, 0}
    assert TTT.match_input("9") == {2, 2}
    assert TTT.match_input("5") == {1, 1}
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
