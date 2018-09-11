defmodule TTT.Utilities.InputParser do

  @moduledoc """

    Parsing player's move inputs(integer or a string of digit) into coordinates.
  """

  @doc """

    ## Parameters

      - move: String of message.

    Display a string with effects correspond on the type of the message.
    If type is not given or does not match, message will be displayed without any effects.
  """
  def parse_input(move) do
    if !is_integer(move) do
      String.to_integer(move)
    else
      move
    end
    |> get_row()
    |> get_coord()
  end

  defp get_row(move) do
    cond do
      move <= 3 -> {0, move}
      move <= 6 -> {1, move}
      move <= 9 -> {2, move}
    end
  end

  defp get_coord({row, move}) do
    {(move - 1 - (3 * row)), row}
  end
end
