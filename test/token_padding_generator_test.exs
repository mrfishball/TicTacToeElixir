defmodule TokenPaddingGeneratorTest do
  alias TTT.Core.Player, as: Player
  alias TTT.Utilities.TokenPaddingGenerator, as: TokenPaddingGenerator
  use ExUnit.Case

  test "The length of the paddings must be the difference between the tokens" do
    long_token = "  vvvvv  "
    short_token = "gg"
    difference = String.length(long_token) - String.length(short_token)
    {left_pad, right_pad} = TokenPaddingGenerator.generate_paddings(long_token, short_token)
    assert String.length(left_pad <> right_pad) == difference
  end

  test "After adding padding, both tokens will have the same legnth" do
    player1 = %Player{name: "Steven", token: "  x  ", type: :human}
    player2 = %Player{name: "Connie", token: "o", type: :human}
    players = {player1, player2}
    {player1, player2} = TokenPaddingGenerator.add_paddings(player1.token, players)
    assert String.length(player1.token) == String.length(player2.token)
  end
end
