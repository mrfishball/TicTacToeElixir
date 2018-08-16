defmodule TTT.Console.Board do
  alias TTT.Console.Colorizer, as: Colorizer
  require Integer

  @moduledoc """
    A command line representation of a game board.
  """

  @board_bounds 0..2

  @doc """

    ## Parameters

      - left_pad, right_pad: empty space(s) around the token for scaling the board according
      to the size of the token.

    Returns a map which contains coordinates as keys and numbers (1 - 9) as values, representing
    available spots on the board.
  """
  def new_board(left_pad, right_pad) do
    for col <- @board_bounds, row <- @board_bounds,
      into: %{}, do: {{col, row}, "#{left_pad}#{(col + row + 1) + (row * 2)}#{right_pad}"}
  end

  @doc """

      ## Parameters

      - board: Map that represents the current state of the board.
      - list: List that contains coordinates that represent moves made by a player.
      - token: String that represents a player's token.

      Returns a map with player's token as value for each coordinate that matches those in
      the list.

      ## Examples

      list = [{0, 1}, {1, 1}, {2, 1}]

      %{
        {0, 0} => "1",
        {0, 1} => "X",
        {0, 2} => "7",
        {1, 0} => "2",
        {1, 1} => "X",
        {1, 2} => "8",
        {2, 0} => "3",
        {2, 1} => "X",
        {2, 2} => "9"
      }

  """
  def register_move(board, list, token) do
    Enum.reduce(list, board, fn point, acc -> Map.put(acc, point, token) end)
  end

  @doc """

    ## Parameters

      - board: Map that represents the current state of the board.
      - token_length: Integer that represents the lenght of the longest token.
      It is use to make sure the row dividers are the same length as the rows.

    Draws a scaled board with it's contents in command line.
  """

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

  defp draw_line(length) do
    str = String.duplicate("-", ((length + 2) * 3) + 2)
    "\n" <> str <> "\n"
  end

  @doc """

    ## Parameters

      - board: Map that represents the current state of the board.
      - moves: Map that contains a collection of players' moves and tokens.
      - token_length: Integer that represents the lenght of the longest token.
      It is use to make sure the row dividers are the same length as the rows.

    Renders and draws the board in command line with tokens as values in
    their corresponding coordinates.
  """
  def render_board(board, %{player_one: {player_one_token, player_one_moves},
                      player_two: {player_two_token, player_two_moves}} = _moves,
                      token_length) do
    board
    |> register_move(player_one_moves, Colorizer.cyan(player_one_token))
    |> register_move(player_two_moves, Colorizer.green(player_two_token))
    |> show_board(token_length)
  end
end
