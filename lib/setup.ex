defmodule Setup do
  def new_game do
    IO.puts "Let's play Tic Tac Toe!\n"
    input = IO.gets "Please select a game mode: \n\n1. Player vs. Player\n2. Player vs. Computer\n3. Spectate a game\n\nYour choice is: "
    String.trim(input)
    |> game_mode()
    |> start()
  end

  def game_mode(choice) do
    cond do
      choice == "1" -> player_vs_player()
      choice == "2" -> player_vs_comp()
      choice == "3" -> comp_vs_comp()
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

  def player_vs_comp do
    player1_name = set_player_name(1)
    player2_name = set_player_name(2)
    player1 = Player.setup(player1_name, :x, :human)
    player2 = Player.setup(player2_name, :o, :computer)
    {player1, player2}
  end

  def comp_vs_comp do
    player1_name = set_player_name(1)
    player2_name = set_player_name(2)
    player1 = Player.setup(player1_name, :x, :computer)
    player2 = Player.setup(player2_name, :o, :computer)
    {player1, player2}
  end

  def set_player_name(player_number) do
    input = IO.gets "Please enter your name (Player #{player_number}): "
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
