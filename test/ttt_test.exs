defmodule TTTTest do
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

  test "A number '1' through '9' will be a valid input" do
    inputs = ["1", "2", "5", "8", "9"]
    for input <- inputs, do: assert TTT.valid_input?(input) == true
  end

  test "Whitespaces before a valid input will be ignored, such input will be a valid one" do
    inputs = ["  3", "    7", " 4"]
    for input <- inputs, do: assert TTT.valid_input?(input) == true
  end

  test "Whitespaces after a valid input will be ignored, such input will be a valid one" do
    inputs = ["1  ", "2    ", "8 "]
    for input <- inputs, do: assert TTT.valid_input?(input) == true
  end

  test "Newlines after a valid input will be ignored, such input will be a valid one" do
    inputs = ["2\n\n", "6\n"]
    for input <- inputs, do: assert TTT.valid_input?(input) == true
  end

  test "Newlines before a valid input will be ignored, such input will be a valid one" do
    inputs = ["\n\n7", "\n3"]
    for input <- inputs, do: assert TTT.valid_input?(input) == true
  end

  test "A number smaller than '1' will be invalidated" do
    invalids = ["-1", "-23", "0"]
    for input <- invalids, do: assert TTT.valid_input?(input) == false
  end

  test "A number greater than '9' will be invalidated" do
    invalids = ["10", "50", "120"]
    for input <- invalids, do: assert TTT.valid_input?(input) == false
  end

  test "Symbols will be invalidated" do
    symbols = ["`", "~", "@", "#", "$"]
    for symbol <- symbols, do: assert TTT.valid_input?(symbol) == false
  end

  test "Letters will be invalidated" do
    letters = ["a", "z", "G", "T"]
    for letter <- letters, do: assert TTT.valid_input?(letter) == false
  end

  test "Empty input, whitespaces and newlines will be invalidated" do
    inputs = ["", " ", "   ", "\n", "\n\n\n"]
    for input <- inputs, do: assert TTT.valid_input?(input) == false
  end

  test "Other characters will be invalidated" do
    inputs = ["哈", "ト", "قلب", "হৃদয়", "หัวใจ"]
    for input <- inputs, do: assert TTT.valid_input?(input) == false
  end

  test "Valid user input will be map to the correct coordinate on the board" do
    assert TTT.match_input(1) == {0, 0}
    assert TTT.match_input(9) == {2, 2}
    assert TTT.match_input(5) == {1, 1}
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

  test "player token is displayed without any whitespaces" do
    player = Player.human({"Steven", "  wewe  "})
    assert capture_io("1", fn -> TTT.get_move_input(player) end) ==
      "Steven - 'wewe', please enter a number from 1 to 9 only: "
  end
end
