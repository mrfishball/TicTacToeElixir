defmodule TTT do

  def main(_args \\ []) do
    GameMaker.new_game()
  end

  def make_a_play(board, game, _status, %Player{name: _name, token: _token, type: :human} = turn) do
      turn
      |> get_move_input()
      |> match_input()
      |> make_a_move(board, game, turn)
  end

  def make_a_play(board, game, _status, %Player{name: _name, token: _token, type: :naive_computer} = turn) do
      game
      |> generate_naive_move(1)
      |> make_a_move(board, game, turn)
  end

  def make_a_play(board, game, _status, %Player{name: _name, token: _token, type: :random_computer} = turn) do
      game
      |> generate_random_move()
      |> make_a_move(board, game, turn)
  end

  def play(board, game, status, %Player{name: _name, token: _token, type: _type} = turn)
    when status == :underway do
      make_a_play(board, game, status, turn)
  end

  def play(_board, _game, {_progress, {outcome, person}} = status, _turn) when status != :underway do
    IO.puts "Game over!\nThe #{outcome} is #{person}!"
  end

  def play(_board, _game, {_progress, outcome} = status, _turn) when status != :underway do
    IO.puts "Game over!\nIt's a #{outcome}!"
  end

  def make_a_move(move, board, game, %Player{name: _name, token: token, type: _type} = turn) do
    with {:ok, game} <- Game.play_turn(game, turn, move) do
      update_visual(board, game)
      status = Game.status(game)
      turn = switch_turn(game, token)
      play(board, game, status, turn)
    else
      {:error, error} -> IO.puts "\nInvalid move: #{error}. Please try again. \n"
      status = Game.status(game)
      play(board, game, status, turn)
    end
  end

  def generate_naive_move(%Game{players: %{p1: player1, p2: player2}} = game, starting_move) do
    move = match_input(starting_move)
    cond do
      MapSet.member?(game.turns[player1.token], move) or
        MapSet.member?(game.turns[player2.token], move) ->
          starting_move = starting_move + 1
          generate_naive_move(game, starting_move)
      true ->
        move
    end
  end

  def generate_random_move(%Game{players: %{p1: player1, p2: player2}} = game) do
    random_input = :rand.uniform(9)
    move = match_input(random_input)
    cond do
      MapSet.member?(game.turns[player1.token], move) or
        MapSet.member?(game.turns[player2.token], move) ->
          generate_random_move(game)
      true ->
        move
    end
  end

  def switch_turn(%Game{players: %{p1: player1, p2: player2}} = _game, last_player) do
    if last_player == player1.token do
      player2
    else
      player1
    end
  end

  def valid_input?(input) do
    Regex.match?(~r/^[1-9]{1}$/, String.trim(input))
  end

  def get_move_input(%Player{name: name, token: token} = turn) do
    move = IO.gets "#{name} - '#{token}', please enter a number from 1 to 9 only: "
    case valid_input?(move) do
      true -> String.to_integer(String.trim(move))
      false ->
        IO.puts "\nInvalid move. Please try again.\n"
        get_move_input(turn)
    end
  end

  def match_input(move) do
    move
    |> get_row()
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

  def update_visual(board, %Game{players: %{p1: player1, p2: player2}, token_length: token_length} = game) do
    player1_moves = MapSet.to_list(game.turns[player1.token])
    player2_moves = MapSet.to_list(game.turns[player2.token])
    moves = %{p1: {player1.token, player1_moves}, p2: {player2.token, player2_moves}}
    Board.render(board, moves, token_length)
  end
end
