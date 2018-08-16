defmodule PlayerTest do
  use ExUnit.Case

  test "Human player struct is correctly created" do
    name = "Steven"
    token = :x
    assert Player.human({name, token}) ==
      %Player{name: "Steven", token: :x, type: :human}
  end

  test "Naive computer player struct is correctly created" do
    name = "Naive computer"
    token = :z
    assert Player.naive_computer({name, token}) ==
      %Player{name: "Naive computer", token: :z, type: :naive_computer}
  end

  test "Random computer player struct is correctly created" do
    name = "Random computer"
    token = :w
    assert Player.random_computer({name, token}) ==
      %Player{name: "Random computer", token: :w, type: :random_computer}
  end

  test "The player with the longest token will be returned" do
    player1 = %Player{name: "Steven", token: "  x  ", type: :human}
    player2 = %Player{name: "Connie", token: "o", type: :human}
    players = {player1, player2}
    assert Player.get_longest_token(players) == "  x  "
  end
end
