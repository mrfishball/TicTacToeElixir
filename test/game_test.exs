defmodule GameTest do
  use ExUnit.Case

  test "player can make a move" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)
    assert {:ok, _game} = Game.play_turn(game, p1, {0, 0})
  end

  test "player can't make a move if the spot is already taken" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p1, {0, 0})
    assert Game.play_turn(game, p2, {0, 0}) == {:error, :cell_taken}

    {:ok, game} = Game.play_turn(game, p2, {0, 1})
    assert Game.play_turn(game, p1, {0, 1}) == {:error, :cell_taken}
  end

  test "player can't make an out-of-bound move" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    assert Game.play_turn(game, p1, {4, 10}) == {:error, :out_of_bounds}
    assert Game.play_turn(game, p2, {0, 6}) == {:error, :out_of_bounds}
    assert Game.play_turn(game, p1, {-2, 8}) == {:error, :out_of_bounds}
  end

  test "player can't play turn twice in a row" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)
    {:ok, game} = Game.play_turn(game, p1, {0, 0})

    assert Game.play_turn(game, p1, {2, 2}) == {:error, :not_your_turn}
  end

  test "player wins horizontally (top line)" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p2, {0, 0})
    {:ok, game} = Game.play_turn(game, p1, {2, 1})
    {:ok, game} = Game.play_turn(game, p2, {1, 0})
    {:ok, game} = Game.play_turn(game, p1, {1, 1})
    {:ok, game} = Game.play_turn(game, p2, {2, 0})

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins horizontally (middle line)" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p2, {0, 1})
    {:ok, game} = Game.play_turn(game, p1, {2, 2})
    {:ok, game} = Game.play_turn(game, p2, {1, 1})
    {:ok, game} = Game.play_turn(game, p1, {1, 0})
    {:ok, game} = Game.play_turn(game, p2, {2, 1})

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins horizontally (bottom line)" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p2, {0, 2})
    {:ok, game} = Game.play_turn(game, p1, {2, 0})
    {:ok, game} = Game.play_turn(game, p2, {1, 2})
    {:ok, game} = Game.play_turn(game, p1, {1, 0})
    {:ok, game} = Game.play_turn(game, p2, {2, 2})

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins vertically (left most)" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p2, {0, 0})
    {:ok, game} = Game.play_turn(game, p1, {2, 1})
    {:ok, game} = Game.play_turn(game, p2, {0, 1})
    {:ok, game} = Game.play_turn(game, p1, {1, 1})
    {:ok, game} = Game.play_turn(game, p2, {0, 2})

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins vertically (middle)" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p2, {1, 0})
    {:ok, game} = Game.play_turn(game, p1, {2, 2})
    {:ok, game} = Game.play_turn(game, p2, {1, 1})
    {:ok, game} = Game.play_turn(game, p1, {2, 0})
    {:ok, game} = Game.play_turn(game, p2, {1, 2})

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins vertically (right most)" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p2, {2, 0})
    {:ok, game} = Game.play_turn(game, p1, {1, 1})
    {:ok, game} = Game.play_turn(game, p2, {2, 1})
    {:ok, game} = Game.play_turn(game, p1, {1, 0})
    {:ok, game} = Game.play_turn(game, p2, {2, 2})

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins diagonally (from top right)" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p2, {2, 0})
    {:ok, game} = Game.play_turn(game, p1, {2, 1})
    {:ok, game} = Game.play_turn(game, p2, {1, 1})
    {:ok, game} = Game.play_turn(game, p1, {0, 1})
    {:ok, game} = Game.play_turn(game, p2, {0, 2})

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins diagonally (from top left)" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p1, {0, 0})
    {:ok, game} = Game.play_turn(game, p2, {2, 1})
    {:ok, game} = Game.play_turn(game, p1, {1, 1})
    {:ok, game} = Game.play_turn(game, p2, {0, 1})
    {:ok, game} = Game.play_turn(game, p1, {2, 2})

    assert Game.status(game) == {:ended, {:winner, "Steven"}}
  end

  test "a draw game" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)

    {:ok, game} = Game.play_turn(game, p2, {0, 0})
    {:ok, game} = Game.play_turn(game, p1, {2, 1})
    {:ok, game} = Game.play_turn(game, p2, {2, 2})
    {:ok, game} = Game.play_turn(game, p1, {1, 1})
    {:ok, game} = Game.play_turn(game, p2, {0, 1})
    {:ok, game} = Game.play_turn(game, p1, {0, 2})
    {:ok, game} = Game.play_turn(game, p2, {2, 0})
    {:ok, game} = Game.play_turn(game, p1, {1, 0})

    assert Game.status(game) != {:ended, :draw}

    {:ok, game} = Game.play_turn(game, p2, {1, 2})

    assert Game.status(game) == {:ended, :draw}
  end

  test "when status says 'underway', the game is still in progress" do
    p1 = Player.human({"Steven", :x})
    p2 = Player.human({"Connie", :o})
    game = Game.setup(p1, p2, 1)
    assert Game.status(game) == :underway

    {:ok, game} = Game.play_turn(game, p1, {0, 1})
    {:ok, game} = Game.play_turn(game, p2, {1, 2})

    assert Game.status(game) == :underway
  end
end
