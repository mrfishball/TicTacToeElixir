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

  def start({player1, player2} = _players) do
    board = Board.setup
    game = Game.setup(player1, player2)
    status = Game.status(game)
    Board.show(board)
    TTT.play(board, game, status, player1)
  end

  def player_vs_player do
    player1 = set_human_player(1, :x)
    player2 = set_human_player(2, :o)
    {player1, player2}
  end

  def player_vs_computer do
    player1 = set_human_player(1, :x)
    player2 = set_computer_player(2, :o)
    {player1, player2}
  end

  def computer_vs_computer do
    player1 = set_computer_player(1, :x)
    player2 = set_computer_player(2, :o)
    {player1, player2}
  end

  def set_human_player(player_number, token) do
    human_name = set_player_name(player_number)
    human_name
    |> Player.human(token)
  end

  def set_computer_player(player_number, token) do
    computer_name = set_player_name(player_number)
    computer_name
    |> computer_type_menu(token)
  end

  def computer_type_menu(computer_name, token) do
      IO.puts "Please choose the type of the computer player:\n"
      IO.puts "1. Naive - (Computer will take the first available spot)"
      IO.puts "2. Random - (Computer will take an available spot randomly)\n"
      input = IO.gets "Your choice is (Enter 1 or 2): "
      input
      |> String.trim()
      |> choose_computer_type(computer_name, token)
  end

  def choose_computer_type(choice, computer_name, token) do
    cond do
      choice == "1" -> Player.naive_computer(computer_name, token)
      choice == "2" -> Player.random_computer(computer_name, token)
      true ->
        IO.puts "\nInvalid entry. Please try again\n"
        computer_type_menu(computer_name, token)
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

  def valid_name?(name) do
    name != ""
  end
end
