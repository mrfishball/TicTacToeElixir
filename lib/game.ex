defmodule Game do

  @enforce_keys [:turns, :last_player]
  defstruct @enforce_keys

  @board_bound 0..2
  @valid_tokens [:x, :o]

  def new do
    %Game{turns: %{x: MapSet.new, o: MapSet.new}, last_player: :player}
  end

  # Check if the potential play is valid before making the actual move
  def play_turn(%Game{turns: turns, last_player: last_player} = state, token, cell) do
    cond do
      token == last_player ->
        {:error, :not_your_turn}
      token not in @valid_tokens ->
        {:error, :invalid_token}
      cell_taken?(turns, cell) ->
        {:error, :cell_taken}
      not in_bounds?(cell) ->
        {:error, :out_of_bounds}
      true ->
        state = update_in(state.turns[token], &MapSet.put(&1, cell))
        {:ok, %{state | last_player: token}}
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
    turns
    |> Map.values
    |> Enum.reduce(0, &(MapSet.size(&1) + &2))
    >= :math.pow(Enum.count(@board_bound), 2)
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

  # Provide game status updates
  def status(%Game{turns: turns}) do
    cond do
      player_won?(turns[:x]) -> {:ended, {:winner, :x}}
      player_won?(turns[:o]) -> {:ended, {:winner, :o}}
      draw?(turns) -> {:ended, :draw}
      true ->
        :underway
    end
  end
end
