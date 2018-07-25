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
    player1_name = set_player_name(1)
    player2_name = set_player_name(2)
    player1 = Player.setup(player1_name, :x, :human)
    player2 = Player.setup(player2_name, :o, :human)
    {player1, player2}
  end

  def player_vs_computer do
    player1_name = set_player_name(1)
    player2_name = set_player_name(2)
    computer = computer_type_menu()
    player1 = Player.setup(player1_name, :x, :human)
    player2 = Player.setup(player2_name, :o, computer)
    {player1, player2}
  end

  def computer_vs_computer do
    player1_name = set_player_name(1)
    computer1 = computer_type_menu()
    player2_name = set_player_name(2)
    computer2 = computer_type_menu()
    player1 = Player.setup(player1_name, :x, computer1)
    player2 = Player.setup(player2_name, :o, computer2)
    {player1, player2}
  end

  def computer_type_menu do
      IO.puts "Please choose the type of the computer player:\n"
      IO.puts "1. Naive - (Computer will take the first available spot)"
      IO.puts "2. Random - (Computer will take an available spot randomly)\n"
      input = IO.gets "Your choice is (Enter 1 or 2): "
      input
      |> String.trim()
      |> choose_computer_type()
  end

  def choose_computer_type(choice) do
    cond do
      choice == "1" -> :naive_computer
      choice == "2" -> :random_computer
      true ->
        IO.puts "\nInvalid entry. Please try again\n"
        computer_type_menu()
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
