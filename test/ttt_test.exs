defmodule TTTTest do
  alias TTT.Console.Board, as: Board
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "Game will automatically switch turn to 'o' after 'x' has played and vice versa" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.human({"Connie", :o})
    game = Game.new_game(player_one, player_two, 1)

    first_player = :x
    assert TTT.switch_turn(game, first_player) ==
      %Player{name: "Connie", token: :o, type: :human}

    first_player = :o
    assert TTT.switch_turn(game, first_player) ==
      %Player{name: "Steven", token: :x, type: :human}
  end

  test "Player tokens are updated and rendered on the board when user provides valid input" do
    board = Board.new_board("", "")
    player_one = Player.human({"Steven", "x"})
    player_two = Player.human({"Connie", "o"})
    game = Game.new_game(player_one, player_two, 1)
    moves = [{0, 0}, {2, 1}, {1, 0}, {1, 1}, {2, 0}]
    game = TestHelpers.simulate_moves(game, player_two, moves, 0)

    assert capture_io(fn -> TTT.update_visual(board, game) end) ==
      "\n\n \e[32mo\e[0m | \e[32mo\e[0m | \e[32mo\e[0m\n-----------\n 4 | \e[36mx\e[0m | \e[36mx\e[0m\n-----------\n 7 | 8 | 9\n\n\n"
  end

  test "Naive computer player will always take the next open spot following opponent's move if there are no preceding spots" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.naive_computer({"Comp", :o})
    game = Game.new_game(player_one, player_two, 1)

    {:ok, game} = Game.play_turn(game, player_one, {0, 0})

    assert TTT.generate_naive_move(game, 1) == {1, 0}
  end

  test "Naive computer player will always take the first available spot preceding the opponent's move" do
    player_one = Player.human({"Steven", :x})
    player_two = Player.naive_computer({"Comp", :o})
    game = Game.new_game(player_one, player_two, 1)

    {:ok, game} = Game.play_turn(game, player_one, {2, 0})

    assert TTT.generate_naive_move(game, 1) == {0, 0}
  end

  test "Random computer will generate random moves" do
    :rand.seed(:exs1024, {123, 123_534, 345_345})
    player_one = Player.human({"Steven", :x})
    player_two = Player.random_computer({"Comp", :o})
    game = Game.new_game(player_one, player_two, 1)

    {:ok, game} = Game.play_turn(game, player_one, {2, 0})

    assert TTT.generate_random_move(game) == {2, 2}
  end
end
