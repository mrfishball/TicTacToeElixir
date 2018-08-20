defmodule Game do

  @moduledoc """

    This module represents the core rules of the game.
  """

  @enforce_keys [:players, :turns, :last_player, :token_length]
  defstruct @enforce_keys

  @board_bound 0..2

  @doc """

    ## Parameters

      - players: Tuple of player structs which contains player's name, token and type.
      - token_length: Integer of the length of the longer token.

    Returns a game struct.
  """
  def new_game({%Player{token: player_one_token} = player_one,
               %Player{token: player_two_token} = player_two},
               token_length) do

    %Game{players: %{player_one: player_one, player_two: player_two},
            turns: %{player_one_token => MapSet.new, player_two_token => MapSet.new},
      last_player: :player,
     token_length: token_length}
  end

  @doc """

    ## Parameters

      - state: Struct of the game.
      - player: Struct of player in turn.
      - cell: Tuple of coordinates of the player's move.

    Returns the updated game struct(state) after checking each conditions.
    If no errors, player's move coordinate will be recorded in the game struct(state)
    and last player updated.
  """
  def play_turn(%Game{turns: turns, last_player: last_player} = state, player, cell) do
    cond do
      player.token == last_player ->
        {:error, :not_your_turn}
      cell_taken?(turns, cell) ->
        {:error, :cell_taken}
      not in_bounds?(cell) ->
        {:error, :out_of_bounds}
      true ->
        state = update_in(state.turns[player.token], &MapSet.put(&1, cell))
        {:ok, %{state | last_player: player.token}}
    end
  end

  @doc """

    ## Parameters

      - {col, row}: Tuple of coordinate that represents a play's move.

    Returns boolean of whether each component of the coordinate is in bound.
  """
  def in_bounds?({col, row}) do
    col in (@board_bound) && row in (@board_bound)
  end

  @doc """

    ## Parameters

      - turns: Mapset of each player's moves.
      - cell: Coordinate of the current move made by a player.

    Returns boolean of whether the cell already exsit in turns.
  """
  def cell_taken?(turns, cell) do
    turns
    |> Map.values
    |> Enum.any?(&Enum.member?(&1, cell))
  end

  @doc """

    ## Parameters

      - %Game: Struct of the game.

    Returns the progress of the game.
  """
  def status(%Game{players: players, turns: turns}) do
    cond do
      player_won?(turns[players.player_one.token]) ->
        {:ended, {:winner, players.player_one.name}}
      player_won?(turns[players.player_two.token]) ->
        {:ended, {:winner, players.player_two.name}}
      draw?(turns) -> {:ended, :draw}
      true ->
        :underway
    end
  end

  defp draw?(turns) do
    current_moves(turns) >= :math.pow(Enum.count(@board_bound), 2)
  end

  defp current_moves(turns) do
    turns
    |> Map.values
    |> Enum.reduce(0, &(MapSet.size(&1) + &2))
  end

  defp player_won?(player_turns) do
    win_patterns =
      win(@board_bound, :horizontal) ++
      win(@board_bound, :vertical) ++
      win(@board_bound, :diagonal)

    win_patterns
    |> Enum.map(&MapSet.new/1)
    |> Enum.any?(&MapSet.subset?(&1, player_turns))
  end

  defp win(bound, :horizontal) do
    for col <- bound, do: for row <- bound, do: {row, col}
  end

  defp win(bound, :vertical) do
    for col <- bound, do: for row <- bound, do: {col, row}
  end

  defp win(bound, :diagonal) do
    max = Enum.count(bound)
    [(for i <- bound, do: {i, i})] ++
      [(for i <- bound, do: {i, max - i - 1})]
  end
end
