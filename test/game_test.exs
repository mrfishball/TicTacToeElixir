defmodule GameTest do
  use ExUnit.Case

  test "player can make a move" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    assert {:ok, _game} = Game.play_turn(game, player_one, {0, 0})
  end

  test "player can't make a move if the spot is already taken" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)

    {:ok, game} = Game.play_turn(game, player_one, {0, 0})
    assert Game.play_turn(game, player_two, {0, 0}) == {:error, :cell_taken}

    {:ok, game} = Game.play_turn(game, player_two, {0, 1})
    assert Game.play_turn(game, player_one, {0, 1}) == {:error, :cell_taken}
  end

  test "player can't make an out-of-bound move" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)

    assert Game.play_turn(game, player_one, {4, 10}) == {:error, :out_of_bounds}
    assert Game.play_turn(game, player_two, {0, 6}) == {:error, :out_of_bounds}
    assert Game.play_turn(game, player_one, {-2, 8}) == {:error, :out_of_bounds}
  end

  test "player can't play turn twice in a row" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    {:ok, game} = Game.play_turn(game, player_one, {0, 0})

    assert Game.play_turn(game, player_one, {2, 2}) == {:error, :not_your_turn}
  end

  test "player wins horizontally (top line)" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{0, 0}, {2, 1}, {1, 0}, {1, 1}, {2, 0}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins horizontally (middle line)" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{0, 1}, {2, 2}, {1, 1}, {1, 0}, {2, 1}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins horizontally (bottom line)" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{0, 2}, {2, 0}, {1, 2}, {1, 0}, {2, 2}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins vertically (left most)" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{0, 0}, {2, 1}, {0, 1}, {1, 1}, {0, 2}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins vertically (middle)" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{1, 0}, {2, 2}, {1, 1}, {2, 0}, {1, 2}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins vertically (right most)" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{2, 0}, {1, 1}, {2, 1}, {1, 0}, {2, 2}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins diagonally (from top right)" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{2, 0}, {2, 1}, {1, 1}, {0, 1}, {0, 2}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert Game.status(game) == {:ended, {:winner, "Connie"}}
  end

  test "player wins diagonally (from top left)" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{0, 0}, {2, 1}, {1, 1}, {0, 1}, {2, 2}]
    game = TestHelpers.simulate_moves(game, player_one, moves, 0)

    assert Game.status(game) == {:ended, {:winner, "Steven"}}
  end

  test "a draw game" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    moves = [{0, 0}, {2, 1}, {2, 2}, {1, 1}, {0, 1}, {0, 2}, {2, 0}, {1, 0}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert Game.status(game) != {:ended, :draw}

    {:ok, game} = Game.play_turn(game, player_two, {1, 2})

    assert Game.status(game) == {:ended, :draw}
  end

  test "when status says 'underway', the game is still in progress" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game({player_one, player_two}, 1)
    assert Game.status(game) == :underway

    {:ok, game} = Game.play_turn(game, player_one, {0, 1})
    {:ok, game} = Game.play_turn(game, player_two, {1, 2})

    assert Game.status(game) == :underway
  end
end
