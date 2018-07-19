defmodule TTTTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest TTT

  test "Game will automatically switch turn to 'o' after 'x' has played and vice versa" do
    first_player = :x
    assert TTT.switch_turn(first_player) == :o

    first_player = :o
    assert TTT.switch_turn(first_player) == :x
  end

  test "A number '1' through '9' will be a valid input" do
    inputs = ["1", "2", "5", "8", "9"]
    for input <- inputs, do: assert TTT.valid_input?(input) == :true
  end

  test "Whitespaces or newlines before or/and after a valid input will be ignored, such input will be a valid one" do
    inputs = ["  3  ", "    7", "4 ", "\n2\n\n"]
    for input <- inputs, do: assert TTT.valid_input?(input) == :true
  end

  test "A number smaller than '1' or greater than '9' will be invalidated" do
    invalids = ["-1", "-23", "0", "10", "50", "120"]
    for input <- invalids, do: assert TTT.valid_input?(input) == :false
  end

  test "Symbols will be invalidated" do
    symbols = ["`", "~", "@", "#", "$"]
    for symbol <- symbols, do: assert TTT.valid_input?(symbol) == :false
  end

  test "Letters will be invalidated" do
    letters = ["a", "z", "G", "T"]
    for letter <- letters, do: assert TTT.valid_input?(letter) == :false
  end

  test "Empty input, whitespaces and newlines will be invalidated" do
    inputs = ["", " ", "   ", "\n", "\n\n\n"]
    for input <- inputs, do: assert TTT.valid_input?(input) == :false
  end

  test "Other characters will be invalidated" do
    inputs = ["哈", "ト", "قلب", "হৃদয়", "หัวใจ"]
    for input <- inputs, do: assert TTT.valid_input?(input) == :false
  end

  test "Valid user input will be map to the correct coordinate on the board" do
    assert TTT.match_input("1") == {0, 0}
    assert TTT.match_input("9") == {2, 2}
    assert TTT.match_input("5") == {1, 1}
  end

  test "Board is updated and rendered correctly" do
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
