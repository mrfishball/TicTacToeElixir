defmodule GameMaker do
  alias TTT.Console.IO, as: ConsoleIO
  alias TTT.Console.Board, as: Board
  alias TTT.Utilities.InputValidators, as: InputValidators
  alias TTT.Utilities.TokenPaddingGenerator, as: TokenPaddingGenerator
  require Integer

  def show_game_menu do
    ConsoleIO.output(Messages.game_menu, MessageFlags.menu)
    Messages.select()
    |> ConsoleIO.input(MessageFlags.request)
    |> game_mode()
  end

  def assemble_game({player_one, _player_two} = players) do
    player_two = reset_symbol_if_identical(players)
    players = {player_one, player_two}

    longest_token = Player.longest_token(players)
    {player_one, player_two} = TokenPaddingGenerator.add_paddings(longest_token, players)

    game = Game.new_game(player_one, player_two, String.length(longest_token))
    status = Game.status(game)

    {left_pad, right_pad} = TokenPaddingGenerator.generate_paddings(longest_token, " ")
    board = Board.new_board(left_pad, right_pad)

    Board.show(board, game.token_length)

    first_player = player_one

    {board, game, status, first_player}
  end

  def game_mode(choice) do
    cond do
      choice == "1" -> player_vs_player()
      choice == "2" -> player_vs_computer()
      choice == "3" -> computer_vs_computer()
      true ->
        ConsoleIO.output(Messages.invalid_entry, MessageFlags.error)
        show_game_menu()
    end
  end

  def player_vs_player do
    player_one = set_human_player(1)
    player_two = set_human_player(2)
    {player_one, player_two}
  end

  def player_vs_computer do
    player_one = set_human_player(1)
    player_two = set_computer_player(2)
    {player_one, player_two}
  end

  def computer_vs_computer do
    player_one = set_computer_player(1)
    player_two = set_computer_player(2)
    {player_one, player_two}
  end

  def reset_symbol_if_identical({player_one, player_two}) do
    cond do
      player_one.token == player_two.token ->
        ConsoleIO.output(Messages.token_take(player_two.token), MessageFlags.error)
        {_player_two_name, new_token} = set_player_symbol(player_two.name)
        player_two = %Player{player_two | token: new_token}
        reset_symbol_if_identical({player_one, player_two})
      true ->
        player_two
    end
  end

  defp set_human_player(player_number) do
    player_number
    |> set_player_name()
    |> set_player_symbol()
    |> Player.human()
  end

  defp set_computer_player(player_number) do
    player_number
    |> set_player_name()
    |> set_player_symbol()
    |> computer_type_menu()
  end

  defp computer_type_menu({computer_name, _token} = payload) do
      ConsoleIO.output(Messages.computer_choice_menu(computer_name), MessageFlags.menu)
      Messages.select()
      |> ConsoleIO.input(MessageFlags.request)
      |> choose_computer_type(payload)
  end

  defp choose_computer_type(choice, payload) do
    cond do
      choice == "1" -> Player.naive_computer(payload)
      choice == "2" -> Player.random_computer(payload)
      true ->
        ConsoleIO.output(Messages.invalid_entry, MessageFlags.error)
        computer_type_menu(payload)
    end
  end

  defp set_player_name(player_number) do
    input = ConsoleIO.input(Messages.player_name(player_number), MessageFlags.request)
    case !InputValidators.empty_input?(input) do
      true -> input
      false ->
        ConsoleIO.output(Messages.invalid_entry, MessageFlags.error)
        set_player_name(player_number)
    end
  end

  defp set_player_symbol(player_name) do
    input = ConsoleIO.input(Messages.player_symbol(player_name), MessageFlags.request)
    case !InputValidators.empty_input?(input) do
      true -> {player_name, input}
      false ->
        ConsoleIO.output(Messages.invalid_entry, MessageFlags.error)
        set_player_symbol(player_name)
    end
  end
end
