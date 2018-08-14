defmodule GameMaker do
  alias TTT.Console.IO, as: ConsoleIO
  alias TTT.Console.Board, as: Board
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

    longest_token_player = longest_token_player(players)
    {player_one, player_two} = add_paddings(longest_token_player, players)
    {left_pad, right_pad} = symbol_paddings(longest_token_player.token, " ")

    game = Game.new_game(player_one, player_two, String.length(longest_token_player.token))
    board = Board.new_board(left_pad, right_pad)
    status = Game.status(game)
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
    case !empty_input?(input) do
      true -> input
      false ->
        ConsoleIO.output(Messages.invalid_entry, MessageFlags.error)
        set_player_name(player_number)
    end
  end

  defp set_player_symbol(player_name) do
    input = ConsoleIO.input(Messages.player_symbol(player_name), MessageFlags.request)
    case !empty_input?(input) do
      true -> {player_name, input}
      false ->
        ConsoleIO.output(Messages.invalid_entry, MessageFlags.error)
        set_player_symbol(player_name)
    end
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

  def add_paddings(player, {player_one, player_two}) do
    cond do
      player != player_one ->
        {left_side, right_side} = symbol_paddings(player.token, player_one.token)
        player_one = %Player{player_one | token: "#{left_side <> player_one.token <> right_side}"}
        {player_one, player_two}
      player != player_two ->
        {left_side, right_side} = symbol_paddings(player.token, player_two.token)
        player_two = %Player{player_two | token: "#{left_side <> player_two.token <> right_side}"}
        {player_one, player_two}
    end
  end

  def symbol_paddings(long_token, short_token) do
    difference = String.length(long_token) - String.length(short_token)
    side = div(difference, 2)
    extra_padding = rem(difference, 2)
    left_side = String.duplicate(" ", side + extra_padding)
    right_side = String.duplicate(" ", side)
    {left_side, right_side}
  end

  def longest_token_player({player_one, player_two}) do
    if String.length(player_one.token) >= String.length(player_two.token) do
      player_one
    else
      player_two
    end
  end

  def empty_input?(input) do
    input = String.trim(input)
    String.length(input) < 1
  end
end
