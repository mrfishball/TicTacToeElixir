defmodule TTT.Utilities.TokenPaddingGenerator do
  alias TTT.Core.Player, as: Player

  @moduledoc """
    Apply paddings(whitespaces) to shorter token so that the visual board
    scales accordingly.
  """

  @doc """

    ## Parameters

      - longest_token: String of the longer token.
      - players: Tuple of player structs which contains player's name, token and type.

    Returns a tupe of players with paddings added to the shorter token.
  """
  def add_paddings(longer_token, {player_one, player_two} = _players) do
    cond do
      longer_token != player_one.token ->
        {left_side, right_side} = generate_paddings(longer_token, player_one.token)
        player_one = %Player{player_one | token: "#{left_side <> player_one.token <> right_side}"}
        {player_one, player_two}

      longer_token != player_two.token ->
        {left_side, right_side} = generate_paddings(longer_token, player_two.token)
        player_two = %Player{player_two | token: "#{left_side <> player_two.token <> right_side}"}
        {player_one, player_two}
    end
  end

  @doc """

    ## Parameters

      -long_token: String of the longer token.
      -short_token: String of the shorter token.

    Returns a tupe of players with paddings added to the shortest token.
  """
  def generate_paddings(long_token, short_token) do
    difference = String.length(long_token) - String.length(short_token)
    side = div(difference, 2)
    extra_padding = rem(difference, 2)
    left_side = String.duplicate(" ", side + extra_padding)
    right_side = String.duplicate(" ", side)
    {left_side, right_side}
  end
end
