defmodule SetupTest do
  use ExUnit.Case

  test "A string with only whitespaces is not a valid name" do
    name = " "
    name2 = "  "
    name3 = "   "
    assert Setup.valid_name?(String.trim(name)) == false
    assert Setup.valid_name?(String.trim(name2)) == false
    assert Setup.valid_name?(String.trim(name3)) == false
  end

  test "An empty string is not a valid name" do
    name = ""
    assert Setup.valid_name?(name) == false
  end

  test "A string with any number of characters is a valid name" do
    name = "a"
    name2 = "abc"
    name3 = "123"
    name4 = "%$#!**(:>/__-=+"
    assert Setup.valid_name?(name) == true
    assert Setup.valid_name?(name2) == true
    assert Setup.valid_name?(name3) == true
    assert Setup.valid_name?(name4) == true
  end

  test "A string that's a combination of characters and whitespaces is a valid name" do
    name = " abc"
    name2 = "zzz  "
    name3 = "  ggtth*&^$$#)    "
    assert Setup.valid_name?(String.trim(name)) == true
    assert Setup.valid_name?(String.trim(name2)) == true
    assert Setup.valid_name?(String.trim(name3)) == true
  end

  test "A string of numbers will not be a valid symbol" do
    symbol = "  1234  "
    assert Setup.valid_symbol?(symbol) == false
  end

  test "The player with the longest token will be returned" do
    player1 = %Player{name: "Steven", token: "  x  ", type: :human}
    player2 = %Player{name: "Connie", token: "o", type: :human}
    players = {player1, player2}
    assert Setup.longest_token_player(players) ==
      %Player{name: "Steven", token: "  x  ", type: :human}
  end

  test "The length of the paddings must be the difference between the tokens" do
    long_token = "  vvvvv  "
    short_token = "gg"
    difference = String.length(long_token) - String.length(short_token)
    {left_pad, right_pad} = Setup.symbol_paddings(long_token, short_token)
    assert String.length(left_pad <> right_pad) == difference
  end

  test "After adding padding, both tokens will have the same legnth" do
    player1 = %Player{name: "Steven", token: "  x  ", type: :human}
    player2 = %Player{name: "Connie", token: "o", type: :human}
    players = {player1, player2}
    {player1, player2} = Setup.add_paddings(player1, players)
    assert String.length(player1.token) == String.length(player2.token)
  end
end
