defmodule Board do

  @board_bounds 0..2
  def new do
    for col <- @board_bounds, row <- @board_bounds, into: %{}, do: {{col, row}, " "}
  end

  def update(board, list, token) do
    Enum.reduce(list, board, fn point, acc -> Map.put(acc, point, token) end)
  end

  def print(board) do
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

  def render(board, list, list2, token, token2) do
    board
    |> fill(list, String.upcase(Atom.to_string(token)))
    |> fill(list2, String.upcase(Atom.to_string(token2)))
    |> print
  end
end
