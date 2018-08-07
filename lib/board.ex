defmodule Board do
  require Integer

  @board_bounds 0..2
  def new_board(left_pad, right_pad) do
    for col <- @board_bounds, row <- @board_bounds,
      into: %{}, do: {{col, row}, "#{left_pad}#{(col + row + 1) + (row * 2)}#{right_pad}"}
  end

  def register_move(board, list, token) do
    Enum.reduce(list, board, fn point, acc -> Map.put(acc, point, token) end)
  end

  def show(board, token_length) do
    InfoRelayAdapter.output("\n")
    line = draw_line(token_length)
    for row <- @board_bounds do
      for col <- @board_bounds do
        " " <> board[{col, row}]
      end
      |> Enum.join(" |")
    end
    |> Enum.join(line)
    |> InfoRelayAdapter.output()
    InfoRelayAdapter.output("\n")
  end

  def draw_line(length) do
    str = String.duplicate("-", ((length + 2) * 3) + 2)
    "\n" <> str <> "\n"
  end

  def render(board, %{player_one: {player_one_token, player_one_moves},
                      player_two: {player_two_token, player_two_moves}} = _moves, token_length) do
    board
    |> register_move(player_one_moves, Colorizer.cyan(player_one_token))
    |> register_move(player_two_moves, Colorizer.green(player_two_token))
    |> show(token_length)
  end
end
