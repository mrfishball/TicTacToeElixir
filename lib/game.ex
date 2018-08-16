defmodule Game do

  @enforce_keys [:players, :turns, :last_player, :token_length]
  defstruct @enforce_keys

  @board_bound 0..2

  def new_game(%Player{token: player_one_token} = player_one,
               %Player{token: player_two_token} = player_two,
               token_length) do

    %Game{players: %{player_one: player_one, player_two: player_two},
            turns: %{player_one_token => MapSet.new, player_two_token => MapSet.new},
      last_player: :player,
     token_length: token_length}
  end

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

  def in_bounds?({col, row}) do
    col in (@board_bound) && row in (@board_bound)
  end

  def cell_taken?(turns, cell) do
    turns
    |> Map.values
    |> Enum.any?(&Enum.member?(&1, cell))
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
end
