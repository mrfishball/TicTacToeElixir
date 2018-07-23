defmodule TTT do

  def main(_args \\ []) do
    new()
  end

  def new do
    IO.puts "Let's play Tic Tac Toe!\n"
    input = IO.gets "Please select a game mode: \n\n1. Player vs. Player\n2. Player vs. Computer\n3. Spectate a game\n\nYour choice is: "
    String.trim(input)
    |> game_mode()
    |> start()
  end

  def game_mode(choice) do
    cond do
      choice == "1" -> player_player()
      choice == "2" -> player_comp()
      choice == "3" -> comp_comp()
    end
  end

  def start({player1, player2} = _players) do
    board = Board.new
    game = Game.new(player1, player2)
    status = Game.status(game)
    Board.show(board)
    play(board, game, status, player1)
  end

  def player_player do
    p1name = set_player_name(1)
    p2name = set_player_name(2)
    player1 = Player.new(p1name, :x, :human)
    player2 = Player.new(p2name, :o, :human)
    {player1, player2}
  end

  def player_comp do
    p1name = set_player_name(1)
    p2name = set_player_name(2)
    player1 = Player.new(p1name, :x, :human)
    player2 = Player.new(p2name, :o, :computer)
    {player1, player2}
  end

  def comp_comp do
    p1name = set_player_name(1)
    p2name = set_player_name(2)
    player1 = Player.new(p1name, :x, :computer)
    player2 = Player.new(p2name, :o, :computer)
    {player1, player2}
  end

  def play(board, game, status, %Player{name: _name, token: _token, type: type} = turn)
    when status == :underway do
    cond do
      type == :human ->
        input = get_input(turn)
        move = match_input(String.trim(input))
        make_a_move(board, game, turn, move)
      type == :computer ->
        input = get_input(turn)
        move = match_input(String.trim(input))
        make_a_move(board, game, turn, move)
    end
  end

  def play(_board, _game, {_progress, {outcome, person}} = status, _turn) when status != :underway do
    IO.puts "Game over!\nThe #{outcome} is #{person}!"
  end

  def play(_board, _game, {_progress, outcome} = status, _turn) when status != :underway do
    IO.puts "Game over!\nIt's a #{outcome}!"
  end

  def make_a_move(board, game, %Player{name: _name, token: token, type: _type} = turn, move) do
    with {:ok, game} <- Game.play_turn(game, token, move) do
      update_visual(board, game)
      status = Game.status(game)
      turn = switch_turn(game, token)
      play(board, game, status, turn)
    else
      {:error, error} -> IO.puts "\nInvalid move: #{error}. Please try again. \n"
      input = get_input(turn)
      move = match_input(String.trim(input))
      make_a_move(board, game, turn, move)
    end
  end

  def switch_turn(%Game{players: %{p1: player1, p2: player2}} = _game, last_player) do
    if last_player == player1.token do
      player2
    else
      player1
    end
  end

  def set_player_name(flag) do
    input = IO.gets "Please enter your name (Player #{flag}): "
    name = String.trim(input)
    case valid_name?(name) do
      true -> name
      false ->
        set_player_name(flag)
    end
  end

  def valid_name?(name) do
    name != ""
  end

  def valid_input?(input) do
    Regex.match?(~r/^[1-9]{1}$/, String.trim(input))
  end

  def get_input(%Player{name: name, token: token} = turn) do
    move = IO.gets "#{name} - '#{token}', please enter a number from 1 to 9 only: "
    case valid_input?(move) do
      true -> move
      false ->
        IO.puts "\nInvalid move. Please try again.\n"
        get_input(turn)
    end
  end

  def match_input(move) do
    move = String.to_integer(move)
    get_row(move)
    |> get_coord(move)
  end

  defp get_row(move) do
    cond do
      move <= 3 -> 0
      move <= 6 -> 1
      move <= 9 -> 2
    end
  end

  defp get_coord(row, move) do
    {(move - 1 - (3 * row)), row}
  end

  def update_visual(board, %Game{turns: %{x: p1moves, o: p2moves}} = _game) do
    moves = %{x: MapSet.to_list(p1moves), o: MapSet.to_list(p2moves)}
    Board.render(board, moves)
  end
end
