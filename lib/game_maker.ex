defmodule GameMaker do
  require Integer

  def new_game() do
    game_menu()
    |> start()
  end

  def game_menu() do
    IO.output(Messages.game_menu, MessageFlags.menu)
    Messages.select()
    |> IO.input(MessageFlags.request)
    |> game_mode()
  end

  def game_mode(choice) do
    cond do
      choice == "1" -> player_vs_player()
      choice == "2" -> player_vs_computer()
      choice == "3" -> computer_vs_computer()
      true ->
        IO.output(Messages.invalid_entry, MessageFlags.error)
        game_menu()
    end
  end

  def start(players) do
    player = longest_token_player(players)
    {player_one, player_two} = add_paddings(player, players)
    {left_pad, right_pad} = symbol_paddings(player.token, " ")

    game = Game.new_game(player_one, player_two, String.length(player.token))
    board = Board.new_board(left_pad, right_pad)
    status = Game.status(game)
    Board.show(board, String.length(player.token))

    TTT.play(board, game, status, player_one)
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

  def set_human_player(player_number) do
    player_number
    |> set_player_name()
    |> set_player_symbol()
    |> Player.human()
  end

  def set_computer_player(player_number) do
    player_number
    |> set_player_name()
    |> set_player_symbol()
    |> computer_type_menu()
  end

  defp computer_type_menu({computer_name, _token} = payload) do
      IO.output(Messages.computer_choice_menu(computer_name), MessageFlags.menu)
      Messages.select()
      |> IO.input(MessageFlags.request)
      |> choose_computer_type(payload)
  end

  defp choose_computer_type(choice, payload) do
    cond do
      choice == "1" -> Player.naive_computer(payload)
      choice == "2" -> Player.random_computer(payload)
      true ->
        IO.output(Messages.invalid_entry, MessageFlags.error)
        computer_type_menu(payload)
    end
  end

  def set_player_name(player_number) do
    input = IO.input(Messages.player_name(player_number), MessageFlags.request)
    case !empty_input?(input) do
      true -> input
      false ->
        IO.output(Messages.invalid_entry, MessageFlags.error)
        set_player_name(player_number)
    end
  end

  def set_player_symbol(player_name) do
    input = IO.input(Messages.player_symbol(player_name), MessageFlags.request)
    case !empty_input?(input) do
      true -> {player_name, input}
      false ->
        IO.output(Messages.invalid_entry, MessageFlags.error)
        set_player_symbol(player_name)
    end
  end

  def add_paddings(player, {player_one, player_two} = _players) do
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

  def longest_token_player({player_one, player_two} = _players) do
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
