defmodule TTT.Console.GameRunner do
  alias TTT.Core.Player, as: Player
  alias TTT.Core.Logic, as: Logic
  alias TTT.Core.GameMaker, as: GameMaker
  alias TTT.Console.Cli, as: Cli

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
    Cli.output(Messages.title, MessageTags.title)
    game_menu_selection()
    |> select_game_mode()
    |> GameMaker.polish_tokens_and_paddings()
    |> GameMaker.assemble_game()
    |> Logic.play()
  end

  defp game_menu_selection do
    Cli.output(Messages.game_menu, MessageTags.menu)
    Messages.select()
    |> Cli.input(MessageTags.request)
  end

  defp computer_type_selection(computer_name) do
    Cli.output(Messages.computer_choice_menu(computer_name), MessageTags.menu)
    Messages.select()
    |> Cli.input(MessageTags.request)
    |> get_computer_type(computer_name)
  end

  defp get_computer_type(choice, computer_name) do
    cond do
      choice == "1" -> &Player.naive_computer/1
      choice == "2" -> &Player.random_computer/1
      true ->
        Cli.output(Messages.invalid_entry, MessageTags.error)
        computer_type_selection(computer_name)
    end
  end

  defp select_game_mode(choice) do
    cond do
      choice == "1" -> player_vs_player()
      choice == "2" -> player_vs_computer()
      choice == "3" -> computer_vs_computer()
      true ->
        Cli.output(Messages.invalid_entry, MessageTags.error)
        new_game()
    end
  end

  defp player_vs_player do
    player_one = GameMaker.setup_player(get_player_name(1), get_player_symbol(1), &Player.human/1)
    player_two = GameMaker.setup_player(get_player_name(2), get_player_symbol(2), &Player.human/1)
    {player_one, player_two}
  end

  defp player_vs_computer do
    player_one = GameMaker.setup_player(get_player_name(1), get_player_symbol(1), &Player.human/1)
    player_two = make_computer_player(get_player_name(2), get_player_symbol(2))
    {player_one, player_two}
  end

  defp computer_vs_computer do
    player_one = make_computer_player(get_player_name(1), get_player_symbol(1))
    player_two = make_computer_player(get_player_name(2), get_player_symbol(2))
    {player_one, player_two}
  end

  defp make_computer_player(player_name, player_token) do
    GameMaker.setup_player(player_name, player_token, computer_type_selection(player_name))
  end

  defp get_player_name(player_number) do
    name = Cli.input(Messages.player_name(player_number), MessageTags.request)
    with {:ok, name} <- GameMaker.check_player_name(name) do
      name
    else
      {:error, name} -> Cli.output(Messages.invalid_name(name), MessageTags.error)
      get_player_name(player_number)
    end
  end

  defp get_player_symbol(player_number) do
    symbol = Cli.input(Messages.player_symbol(player_number), MessageTags.request)
    with {:ok, token} <- GameMaker.check_player_symbol(symbol) do
      token
    else
      {:error, token} -> Cli.output(Messages.invalid_token(token), MessageTags.error)
      get_player_symbol(player_number)
    end
  end
end
