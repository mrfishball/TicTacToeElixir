defmodule GameMakerTest do
  use ExUnit.Case

  test "string with whitespace will be consider an empty string" do
    assert GameMaker.empty_input?(" ") == true
  end

  test "a string with trailing whitespaces will not be consider an empty string" do
    assert GameMaker.empty_input?(" Steven  ") == false
  end

  test "The player with the longest token will be returned" do
    player1 = %Player{name: "Steven", token: "  x  ", type: :human}
    player2 = %Player{name: "Connie", token: "o", type: :human}
    players = {player1, player2}
    assert GameMaker.longest_token_player(players) ==
      %Player{name: "Steven", token: "  x  ", type: :human}
  end

  test "The length of the paddings must be the difference between the tokens" do
    long_token = "  vvvvv  "
    short_token = "gg"
    difference = String.length(long_token) - String.length(short_token)
    {left_pad, right_pad} = GameMaker.symbol_paddings(long_token, short_token)
    assert String.length(left_pad <> right_pad) == difference
  end

  test "After adding padding, both tokens will have the same legnth" do
    player1 = %Player{name: "Steven", token: "  x  ", type: :human}
    player2 = %Player{name: "Connie", token: "o", type: :human}
    players = {player1, player2}
    {player1, player2} = GameMaker.add_paddings(player1, players)
    assert String.length(player1.token) == String.length(player2.token)
  end
end
