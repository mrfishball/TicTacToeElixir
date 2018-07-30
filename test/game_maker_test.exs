defmodule GameMakerTest do
  use ExUnit.Case

  test "A string with only whitespaces is not a valid name" do
    name = " "
    name2 = "  "
    name3 = "   "
    assert GameMaker.valid_name?(String.trim(name)) == false
    assert GameMaker.valid_name?(String.trim(name2)) == false
    assert GameMaker.valid_name?(String.trim(name3)) == false
  end

  test "An empty string is not a valid name" do
    name = ""
    assert GameMaker.valid_name?(name) == false
  end

  test "A string with any number of characters is a valid name" do
    name = "a"
    name2 = "abc"
    name3 = "123"
    name4 = "%$#!**(:>/__-=+"
    assert GameMaker.valid_name?(name) == true
    assert GameMaker.valid_name?(name2) == true
    assert GameMaker.valid_name?(name3) == true
    assert GameMaker.valid_name?(name4) == true
  end

  test "A string that's a combination of characters and whitespaces is a valid name" do
    name = " abc"
    name2 = "zzz  "
    name3 = "  ggtth*&^$$#)    "
    assert GameMaker.valid_name?(String.trim(name)) == true
    assert GameMaker.valid_name?(String.trim(name2)) == true
    assert GameMaker.valid_name?(String.trim(name3)) == true
  end

  test "A string of letters is a valid symbol" do
    symbol = "asddfer"
    symbol2 = "aa"
    symbol3 = "AsdGdK"
    assert GameMaker.valid_symbol?(symbol) == true
    assert GameMaker.valid_symbol?(symbol2) == true
    assert GameMaker.valid_symbol?(symbol3) == true
  end

  test "Spaces around a valid symbol is not allowed" do
    symbol = "   asdfegr "
    assert GameMaker.valid_symbol?(symbol) == false
  end

  test "Empty spaces and string are not valid symbols" do
    symbol = ""
    symbol2 = "   "
    assert GameMaker.valid_symbol?(symbol) == false
    assert GameMaker.valid_symbol?(symbol2) == false
  end

  test "A string of numbers will not be a valid symbol" do
    symbol = "  1234  "
    assert GameMaker.valid_symbol?(symbol) == false
  end

  test "A string of special characters is not a valid symbol" do
    symbol = "*&^())"
    assert GameMaker.valid_symbol?(symbol) == false
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
