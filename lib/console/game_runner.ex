defmodule TTT.Console.GameRunner do

  @moduledoc """
    A command line game runner.
  """

  def main(_args \\ []) do
    new_game()
  end

  @doc """

    Display a game title, menu and asking for game mode input to properly setup the game.
  """
  def new_game do
    IOcontroller.output(Messages.title, MessageFlags.title)
    game_menu_selection()
    |> select_game_mode()
    |> GameMaker.polish_tokens_and_paddings()
    |> GameMaker.assemble_game()
    |> TTT.play()
  end

  defp game_menu_selection do
    IOcontroller.output(Messages.game_menu, MessageFlags.menu)
    Messages.select()
    |> IOcontroller.input(MessageFlags.request)
  end

  defp select_game_mode(choice) do
    cond do
      choice == "1" -> GameMaker.player_vs_player()
      choice == "2" -> GameMaker.player_vs_computer()
      choice == "3" -> GameMaker.computer_vs_computer()
      true ->
        IOcontroller.output(Messages.invalid_entry, MessageFlags.error)
        new_game()
    end
  end
end
