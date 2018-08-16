defmodule TTT.Console.GameRunner do
  alias TTT.Console.IO, as: ConsoleIO

  def main(_args \\ []) do
    new_game()
  end

  def new_game do
    ConsoleIO.output(Messages.title, MessageFlags.title)
    game_menu_selection()
    |> select_game_mode()
    |> GameMaker.assemble_game()
    |> TTT.play()
  end

  def game_menu_selection do
    ConsoleIO.output(Messages.game_menu, MessageFlags.menu)
    Messages.select()
    |> ConsoleIO.input(MessageFlags.request)
  end

  def select_game_mode(choice) do
    cond do
      choice == "1" -> GameMaker.player_vs_player()
      choice == "2" -> GameMaker.player_vs_computer()
      choice == "3" -> GameMaker.computer_vs_computer()
      true ->
        ConsoleIO.output(Messages.invalid_entry, MessageFlags.error)
        new_game()
    end
  end
end
