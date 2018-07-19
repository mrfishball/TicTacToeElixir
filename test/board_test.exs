defmodule BoardTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Board

  test "Board has all the correct coordinates and they are represented by empty slots" do
    board = Board.new
    assert board == %{
              {0, 0} => "1",
              {0, 1} => "4",
              {0, 2} => "7",
              {1, 0} => "2",
              {1, 1} => "5",
              {1, 2} => "8",
              {2, 0} => "3",
              {2, 1} => "6",
              {2, 2} => "9"
            }
  end

  test "Selected spot is correctly put on the board with the " do
    board = Board.new
    coords = [{0, 2}, {1, 0}, {2, 1}, {1, 2}]
    token = :x
    assert Board.register_move(board, coords, token) == %{
              {0, 0} => "1",
              {0, 1} => "4",
              {0, 2} => :x,
              {1, 0} => :x,
              {1, 1} => "5",
              {1, 2} => :x,
              {2, 0} => "3",
              {2, 1} => :x,
              {2, 2} => "9"
            }
  end

  test "To print an empty board in CLI" do
    board = Board.new
    assert capture_io(fn -> Board.show(board) end) ==
      "\n\n 1 | 2 | 3\n---+---+---\n 4 | 5 | 6\n---+---+---\n 7 | 8 | 9\n\n\n"
  end

  test "Update the board's visual on a valid moves in CLI" do
    board = Board.new
    moves = %{x: [{0, 0}, {2, 1}, {1, 2}], o: [{1, 0}, {1, 1}, {2, 2}]}
    assert capture_io(fn ->
      Board.render(board, moves) end) ==
        "\n\n x | o | 3\n---+---+---\n 4 | o | x\n---+---+---\n 7 | x | o\n\n\n"
  end
end
