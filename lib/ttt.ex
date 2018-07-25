defmodule TTT do

  def main(_args \\ []) do
    Setup.new_game()
  end

  def play(board, game, status, %Player{name: _name, token: _token, type: type} = turn)
    when status == :underway do
    cond do
      type == :human ->
        turn
        |> get_move()
        |> match_input()
        |> make_a_move(board, game, turn)
      type == :naive_comp ->
        game
        |> generate_naive_move(1)
        |> make_a_move(board, game, turn)
      true ->
        game
        |> generate_random_move()
        |> make_a_move(board, game, turn)
    end
  end

  def play(_board, _game, {_progress, {outcome, person}} = status, _turn) when status != :underway do
    IO.puts "Game over!\nThe #{outcome} is #{person}!"
  end

  def play(_board, _game, {_progress, outcome} = status, _turn) when status != :underway do
    IO.puts "Game over!\nIt's a #{outcome}!"
  end

  def make_a_move(move, board, game, %Player{name: _name, token: token, type: _type} = turn) do
    with {:ok, game} <- Game.play_turn(game, token, move) do
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

  def generate_naive_move(%Game{turns: %{x: p1moves, o: p2moves}} = game, starting_move) do
    move = match_input(starting_move)
    cond do
      MapSet.member?(p1moves, move) or MapSet.member?(p2moves, move) ->
        starting_move = starting_move + 1
        generate_naive_move(game, starting_move)
      true ->
        move
    end
  end

  def generate_random_move(%Game{turns: %{x: p1moves, o: p2moves}} = game) do
    random_input = :rand.uniform(9)
    move = match_input(random_input)
    cond do
      MapSet.member?(p1moves, move) or MapSet.member?(p2moves, move) ->
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

  def get_move(%Player{name: name, token: token} = turn) do
    move = IO.gets "#{name} - '#{token}', please enter a number from 1 to 9 only: "
    case valid_input?(move) do
      true -> String.to_integer(String.trim(move))
      false ->
        IO.puts "\nInvalid move. Please try again.\n"
        get_move(turn)
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

  def update_visual(board, %Game{turns: %{x: p1moves, o: p2moves}} = _game) do
    moves = %{x: MapSet.to_list(p1moves), o: MapSet.to_list(p2moves)}
    Board.render(board, moves)
  end
end
