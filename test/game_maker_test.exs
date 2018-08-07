defmodule GameMakerTest do
  use ExUnit.Case

  test "A string with only whitespaces is not a valid name" do
    assert GameMaker.valid_name?("  ") == false
  end

  test "An empty string is not a valid name" do
    assert GameMaker.valid_name?("") == false
  end

  test "A string with any number of characters is a valid name" do
    assert GameMaker.valid_name?("a") == true
    assert GameMaker.valid_name?("abcde") == true
    assert GameMaker.valid_name?("12356789") == true
    assert GameMaker.valid_name?("%$#!**(:>/__-=+") == true
  end

  test "A string that's a combination of characters and whitespaces is a valid name" do
    assert GameMaker.valid_name?("  ggtth*&^$$#)    ") == true
  end

  test "A String with whitespaces only are not valid symbols" do
    assert GameMaker.valid_symbol?("  ") == false
  end

  test "Empty string are not valid symbols" do
    assert GameMaker.valid_symbol?("") == false
  end

  test "A string of letters is a valid symbol" do
    assert GameMaker.valid_symbol?("AsdGdK") == true
  end

  test "A string of numbers will be a valid symbol" do
    assert GameMaker.valid_symbol?("1234") == true
  end

  test "A string of special characters is a valid symbol" do
    assert GameMaker.valid_symbol?("*&^())") == true
  end

  test "Spaces around a valid symbol is allowed" do
    assert GameMaker.valid_symbol?("  *&^12Adcr())") == true
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
