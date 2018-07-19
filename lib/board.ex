defmodule Board do
  @moduledoc false
  def new do
    for col <- 0..2, row <- 0..2, into: %{}, do: {{col, row}, " "}
  end

  defp put(board, {col, row}, val) do
    Map.put(board, {col, row}, val)
  end

  # Break down and register each move in the list and it's token onto the board
  def fill(board, list, token) do
    Enum.reduce(list, board, fn point, acc -> put(acc, point, token) end)
  end

  def print(board) do
    IO.puts "\n"
    for row <- 0..2 do
      for col <- 0..2 do
        " " <> board[{col, row}]
      end
      |> Enum.join(" |")
    end
    |> Enum.join("\n---+---+---\n")
    |> IO.puts()
    IO.puts "\n"
  end

  def update(board, list, list2, token, token2) do
    board
    |> fill(list, String.upcase(Atom.to_string(token)))
    |> fill(list2, String.upcase(Atom.to_string(token2)))
    |> print
  end
end
