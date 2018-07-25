defmodule Setup do
  def new_game do
    IO.puts "Let's play Tic Tac Toe!\n"
    game_menu()
    |> game_mode()
    |> start()
  end

  def game_menu do
    input = IO.gets "Please select a game mode: \n\n1. Player vs. Player\n2. Player vs. Computer\n3. Spectate a game\n\nYour choice is: "
    String.trim(input)
  end

  def game_mode(choice) do
    cond do
      choice == "1" -> player_vs_player()
      choice == "2" -> player_vs_comp()
      choice == "3" -> comp_vs_comp()
      true ->
        IO.puts "\nInvalid entry. Please try again.\n"
        game_menu()
    end
  end

  def start({player1, player2} = _players) do
    board = Board.setup
    game = Game.setup(player1, player2)
    IO.inspect(game.players.p2)
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

  def player_vs_comp do
    player1_name = set_player_name(1)
    player2_name = set_player_name(2)
    comp_type = comp_type_menu()
    player1 = Player.setup(player1_name, :x, :human)
    player2 = Player.setup(player2_name, :o, comp_type)
    {player1, player2}
  end

  def comp_vs_comp do
    player1_name = set_player_name(1)
    comp1_type = comp_type_menu()
    player2_name = set_player_name(2)
    comp2_type = comp_type_menu()
    player1 = Player.setup(player1_name, :x, comp1_type)
    player2 = Player.setup(player2_name, :o, comp2_type)
    {player1, player2}
  end

  def comp_type_menu do
      IO.puts "Please choose the type of the computer player:\n"
      IO.puts "1. Navie - (Computer will take the first available spot)"
      IO.puts "2. Random - (Computer will take an available spot randomly)\n"
      input = IO.gets "Your choice is (Enter 1 or 2): "
      input
      |> String.trim()
      |> choose_comp_type()
  end

  def choose_comp_type(choice) do
    cond do
      choice == "1" -> :naive_comp
      choice == "2" -> :random_comp
      true ->
        IO.puts "\nInvalid entry. Please try again\n"
        comp_type_menu()
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
