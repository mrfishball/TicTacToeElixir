defmodule TTT.Utilities.TokenPaddingGenerator do

  def add_paddings(longest_token, {player_one, player_two}) do
    cond do
      longest_token != player_one.token ->
        {left_side, right_side} = generate_paddings(longest_token, player_one.token)
        player_one = %Player{player_one | token: "#{left_side <> player_one.token <> right_side}"}
        {player_one, player_two}

      longest_token != player_two.token ->
        {left_side, right_side} = generate_paddings(longest_token, player_two.token)
        player_two = %Player{player_two | token: "#{left_side <> player_two.token <> right_side}"}
        {player_one, player_two}
    end
  end

  def generate_paddings(long_token, short_token) do
    difference = String.length(long_token) - String.length(short_token)
    side = div(difference, 2)
    extra_padding = rem(difference, 2)
    left_side = String.duplicate(" ", side + extra_padding)
    right_side = String.duplicate(" ", side)
    {left_side, right_side}
  end
end
