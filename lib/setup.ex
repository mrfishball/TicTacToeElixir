defmodule Setup do
  require Integer

  def new_game do
    IO.puts "Let's play Tic Tac Toe!\n"
    game_menu()
    |> start()
  end

  def game_menu do
    input = IO.gets "Please select a game mode: \n\n1. Player vs. Player\n2. Player vs. Computer\n3. Spectate a game\n\nYour choice is: "
    input
    |> String.trim()
    |> game_mode()
  end

  def game_mode(choice) do
    cond do
      choice == "1" -> player_vs_player()
      choice == "2" -> player_vs_computer()
      choice == "3" -> computer_vs_computer()
      true ->
        IO.puts "\nInvalid entry. Please try again.\n"
        game_menu()
    end
  end

  def start(players) do
    player = longest_token_player(players)
    {player1, player2} = add_paddings(player, players)
    {left_pad, right_pad} = symbol_paddings(player.token, " ")

    game = Game.setup(player1, player2, String.length(player.token))
    board = Board.setup(left_pad, right_pad)
    status = Game.status(game)
    Board.show(board, String.length(player.token))
    
    TTT.play(board, game, status, player1)
  end

  def player_vs_player do
    player1 = set_human_player(1)
    player2 = set_human_player(2)
    {player1, player2}
  end

  def player_vs_computer do
    player1 = set_human_player(1)
    player2 = set_computer_player(2)
    {player1, player2}
  end

  def computer_vs_computer do
    player1 = set_computer_player(1)
    player2 = set_computer_player(2)
    {player1, player2}
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
      IO.puts "Please choose the type of the computer player - '#{computer_name}':\n"
      IO.puts "1. Naive - ('#{computer_name}' will take the first available spot)"
      IO.puts "2. Random - ('#{computer_name}' will take an available spot randomly)\n"
      input = IO.gets "Your choice is (Enter 1 or 2): "
      input
      |> String.trim()
      |> choose_computer_type(payload)
  end

  defp choose_computer_type(choice, payload) do
    cond do
      choice == "1" -> Player.naive_computer(payload)
      choice == "2" -> Player.random_computer(payload)
      true ->
        IO.puts "\nInvalid entry. Please try again\n"
        computer_type_menu(payload)
    end
  end

  def set_player_symbol(player_name) do
    input = IO.gets "Enter a symbol for player '#{player_name}: "
    symbol = String.trim(input)
    case valid_symbol?(symbol) do
      true -> {player_name, symbol}
      false ->
        IO.puts "This is not a valid symbol. Please try again.\n"
        set_player_symbol(player_name)
    end
  end

  def add_paddings(player, {player1, player2} = _players) do
    cond do
      player != player1 ->
        {left_side, right_side} = symbol_paddings(player.token, player1.token)
        player1 = %Player{player1 | token: "#{left_side <> player1.token <> right_side}"}
        {player1, player2}
      player != player2 ->
        {left_side, right_side} = symbol_paddings(player.token, player2.token)
        player2 = %Player{player2 | token: "#{left_side <> player2.token <> right_side}"}
        {player1, player2}
    end
  end

  def symbol_paddings(longer_token, shorter_token) do
    difference = String.length(longer_token) - String.length(shorter_token)
    side = div(difference, 2)
    extra_padding = rem(difference, 2)
    left_side = String.duplicate(" ", side + extra_padding)
    right_side = String.duplicate(" ", side)
    {left_side, right_side}
  end

  def set_player_name(player_number) do
    input = IO.gets "\nPlease enter your name (Player #{player_number}): "
    name = String.trim(input)
    case valid_name?(name) do
      true -> name
      false ->
        IO.puts "This is not a valid name. Please try again.\n"
        set_player_name(player_number)
    end
  end

  def longest_token_player({player1, player2} = _players) do
    if String.length(player1.token) >= String.length(player2.token) do
      player1
    else
      player2
    end
  end

  def valid_symbol?(symbol) do
    Regex.match?(~r/^[a-zA-Z&.\-]*$/, symbol)
  end

  def valid_name?(name) do
    name != ""
  end
end
