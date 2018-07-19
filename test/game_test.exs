defmodule GameTest do
  use ExUnit.Case
  doctest Game

  test "player can make a move" do
    game = Game.new
    assert {:ok, _game} = Game.play_turn(game, :x, {0, 0})
  end

  test "player can't make a move if the spot is already taken" do
    game = Game.new

    {:ok, game} = Game.play_turn(game, :x, {0, 0})
    assert Game.play_turn(game, :o, {0, 0}) == {:error, :cell_taken}

    {:ok, game} = Game.play_turn(game, :o, {0, 1})
    assert Game.play_turn(game, :x, {0, 1}) == {:error, :cell_taken}
  end

  test "player can't make an out-of-bound move" do
    game = Game.new
    assert Game.play_turn(game, :x, {4, 10}) == {:error, :out_of_bounds}
    assert Game.play_turn(game, :o, {0, 6}) == {:error, :out_of_bounds}
    assert Game.play_turn(game, :x, {-2, 8}) == {:error, :out_of_bounds}
  end

  test "player with invalid token can't play turn" do
    game = Game.new
    assert Game.play_turn(game, :a, {0, 0}) == {:error, :invalid_token}
    assert Game.play_turn(game, :some_token, {1, 1}) == {:error, :invalid_token}
  end

  test "player can't play turn twice in a row" do
    game = Game.new
    {:ok, game} = Game.play_turn(game, :x, {0, 0})
    assert Game.play_turn(game, :x, {2, 2}) == {:error, :not_your_turn}
  end

  test "player wins horizontally (top line)" do
    game = Game.new

    {:ok, game} = Game.play_turn(game, :o, {0, 0})
    {:ok, game} = Game.play_turn(game, :x, {2, 1})
    {:ok, game} = Game.play_turn(game, :o, {1, 0})
    {:ok, game} = Game.play_turn(game, :x, {1, 1})
    {:ok, game} = Game.play_turn(game, :o, {2, 0})

    assert Game.status(game) == {:ended, {:winner, :o}}
  end

  test "player wins horizontally (middle line)" do
    game = Game.new

    {:ok, game} = Game.play_turn(game, :o, {0, 1})
    {:ok, game} = Game.play_turn(game, :x, {2, 2})
    {:ok, game} = Game.play_turn(game, :o, {1, 1})
    {:ok, game} = Game.play_turn(game, :x, {1, 0})
    {:ok, game} = Game.play_turn(game, :o, {2, 1})

    assert Game.status(game) == {:ended, {:winner, :o}}
  end

  test "player wins horizontally (bottom line)" do
    game = Game.new

    {:ok, game} = Game.play_turn(game, :o, {0, 2})
    {:ok, game} = Game.play_turn(game, :x, {2, 0})
    {:ok, game} = Game.play_turn(game, :o, {1, 2})
    {:ok, game} = Game.play_turn(game, :x, {1, 0})
    {:ok, game} = Game.play_turn(game, :o, {2, 2})

    assert Game.status(game) == {:ended, {:winner, :o}}
  end

  test "player wins vertically (left most)" do
    game = Game.new

    {:ok, game} = Game.play_turn(game, :o, {0, 0})
    {:ok, game} = Game.play_turn(game, :x, {2, 1})
    {:ok, game} = Game.play_turn(game, :o, {0, 1})
    {:ok, game} = Game.play_turn(game, :x, {1, 1})
    {:ok, game} = Game.play_turn(game, :o, {0, 2})

    assert Game.status(game) == {:ended, {:winner, :o}}
  end

  test "player wins vertically (middle)" do
    game = Game.new

    {:ok, game} = Game.play_turn(game, :o, {1, 0})
    {:ok, game} = Game.play_turn(game, :x, {2, 2})
    {:ok, game} = Game.play_turn(game, :o, {1, 1})
    {:ok, game} = Game.play_turn(game, :x, {2, 0})
    {:ok, game} = Game.play_turn(game, :o, {1, 2})

    assert Game.status(game) == {:ended, {:winner, :o}}
  end

  test "player wins vertically (right most)" do
    game = Game.new

    {:ok, game} = Game.play_turn(game, :o, {2, 0})
    {:ok, game} = Game.play_turn(game, :x, {1, 1})
    {:ok, game} = Game.play_turn(game, :o, {2, 1})
    {:ok, game} = Game.play_turn(game, :x, {1, 0})
    {:ok, game} = Game.play_turn(game, :o, {2, 2})

    assert Game.status(game) == {:ended, {:winner, :o}}
  end

  test "player wins diagonally (from top right)" do
    game = Game.new

    {:ok, game} = Game.play_turn(game, :o, {2, 0})
    {:ok, game} = Game.play_turn(game, :x, {2, 1})
    {:ok, game} = Game.play_turn(game, :o, {1, 1})
    {:ok, game} = Game.play_turn(game, :x, {0, 1})
    {:ok, game} = Game.play_turn(game, :o, {0, 2})

    assert Game.status(game) == {:ended, {:winner, :o}}
  end

  test "player wins diagonally (from top left)" do
    game = Game.new

    {:ok, game2} = Game.play_turn(game2, :x, {0, 0})
    {:ok, game2} = Game.play_turn(game2, :o, {2, 1})
    {:ok, game2} = Game.play_turn(game2, :x, {1, 1})
    {:ok, game2} = Game.play_turn(game2, :o, {0, 1})
    {:ok, game2} = Game.play_turn(game2, :x, {2, 2})

    assert Game.status(game2) == {:ended, {:winner, :x}}
  end

  test "a draw game" do
    game = Game.new
    {:ok, game} = Game.play_turn(game, :o, {0, 0})
    {:ok, game} = Game.play_turn(game, :x, {2, 1})
    {:ok, game} = Game.play_turn(game, :o, {2, 2})
    {:ok, game} = Game.play_turn(game, :x, {1, 1})
    {:ok, game} = Game.play_turn(game, :o, {0, 1})
    {:ok, game} = Game.play_turn(game, :x, {0, 2})
    {:ok, game} = Game.play_turn(game, :o, {2, 0})
    {:ok, game} = Game.play_turn(game, :x, {1, 0})

    assert Game.status(game) != {:ended, :draw}

    {:ok, game} = Game.play_turn(game, :o, {1, 2})

    assert Game.status(game) == {:ended, :draw}
  end

  test "when status says 'underway', the game is still in progress" do
    game = Game.new
    assert Game.status(game) == :underway

    {:ok, game} = Game.play_turn(game, :x, {0, 1})
    {:ok, game} = Game.play_turn(game, :o, {1, 2})

    assert Game.status(game) == :underway
  end
end
