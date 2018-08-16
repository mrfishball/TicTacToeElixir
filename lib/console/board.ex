defmodule TTT.Console.Board do
  alias TTT.Console.Colorizer, as: Colorizer
  require Integer

  @moduledoc """
    A command line representation of a game board
  """

  @board_bounds 0..2

  @doc """

    ## Parameters

      - left_pad, right_pad: empty space(s) around the token for scaling the board according
      to the size of the token

    Returns a map which contains coordinates as keys and numbers (1 - 9) as values, representing
    available spots on the board
  """
  def new_board(left_pad, right_pad) do
    for col <- @board_bounds, row <- @board_bounds,
      into: %{}, do: {{col, row}, "#{left_pad}#{(col + row + 1) + (row * 2)}#{right_pad}"}
  end

  @doc """
    @param board - the current board
    @param list - a list of coordinates representing moves made by a player
  """
  def register_move(board, list, token) do
    Enum.reduce(list, board, fn point, acc -> Map.put(acc, point, token) end)
  end

  def show_board(board, token_length) do
    IOcontroller.output("\n")
    line = draw_line(token_length)
    for row <- @board_bounds do
      for col <- @board_bounds do
        " " <> board[{col, row}]
      end
      |> Enum.join(" |")
    end
    |> Enum.join(line)
    |> IOcontroller.output()
    IOcontroller.output("\n")
  end

  def draw_line(length) do
    str = String.duplicate("-", ((length + 2) * 3) + 2)
    "\n" <> str <> "\n"
  end

  def render_board(board, %{player_one: {player_one_token, player_one_moves},
                      player_two: {player_two_token, player_two_moves}},
                      token_length) do
    board
    |> register_move(player_one_moves, Colorizer.cyan(player_one_token))
    |> register_move(player_two_moves, Colorizer.green(player_two_token))
    |> show_board(token_length)
  end
end
