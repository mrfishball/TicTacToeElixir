defmodule Setup do
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

  def start({player1, player2} = players) do
    token_length = get_longest_token(players)
    board = Board.setup(token_length)
    game = Game.setup(player1, player2, token_length)
    status = Game.status(game)
    Board.show(board, token_length)
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

  def get_longest_token({player1, player2} = _players) do
    token1_length = String.length(player1.token)
    token2_length = String.length(player2.token)
    if token1_length >= token2_length do
      token1_length
    else
      token2_length
    end
  end

  def valid_symbol?(symbol) do
    Regex.match?(~r/^[a-zA-Z&.\-]*$/, symbol)
  end

  def valid_name?(name) do
    name != ""
  end
end
