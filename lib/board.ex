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
    IO.puts "\n"
    line = draw_line(token_length)
    for row <- @board_bounds do
      for col <- @board_bounds do
        " " <> board[{col, row}]
      end
      |> Enum.join(" |")
    end
    |> Enum.join(line)
    |> IO.puts()
    IO.puts "\n"
  end

  def draw_line(length) do
    str = String.duplicate("-", ((length + 2) * 3) + 2)
    "\n" <> str <> "\n"
  end

  def render(board, %{p1: {p1token, p1moves}, p2: {p2token, p2moves}} = _moves, token_length) do
    board
    |> register_move(p1moves, p1token)
    |> register_move(p2moves, p2token)
    |> show(token_length)
  end
end
