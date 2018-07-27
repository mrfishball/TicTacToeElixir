defmodule Board do

  @board_bounds 0..2
  def setup do
    for col <- @board_bounds, row <- @board_bounds,
      into: %{}, do: {{col, row}, "#{(col + row + 1) + (row * 2)}"}
  end

  def register_move(board, list, token) do
    Enum.reduce(list, board, fn point, acc -> Map.put(acc, point, token) end)
  end

  def show(board) do
    IO.puts "\n"
    for row <- @board_bounds do
      for col <- @board_bounds do
        " " <> board[{col, row}]
      end
      |> Enum.join(" |")
    end
    |> Enum.join("\n---+---+---\n")
    |> IO.puts()
    IO.puts "\n"
  end

  def render(board, %{p1: {p1token, p1moves}, p2: {p2token, p2moves}} = _moves) do
    board
    |> register_move(p1moves, p1token)
    |> register_move(p2moves, p2token)
    |> show
  end
end
