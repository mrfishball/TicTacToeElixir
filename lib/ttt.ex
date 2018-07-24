defmodule TTT do

  def main(_args \\ []) do
    Setup.new_game()
  end

  def play(board, game, status, %Player{name: _name, token: _token, type: type} = turn)
    when status == :underway do
    cond do
      type == :human ->
        input = get_move(turn)
        move = match_input(String.trim(input))
        make_a_move(board, game, turn, move)
      type == :computer ->
        move = generate_move(game, 1)
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
      input = get_move(turn)
      move = match_input(String.trim(input))
      make_a_move(board, game, turn, move)
    end
  end

  def generate_move(%Game{turns: %{x: p1moves, o: p2moves}} = game, starting_move) do
    input_string = Integer.to_string(starting_move)
    move = match_input(input_string)
    cond do
      MapSet.member?(p1moves, move) or MapSet.member?(p2moves, move) ->
        starting_move = starting_move + 1
        generate_move(game, starting_move)
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
      true -> move
      false ->
        IO.puts "\nInvalid move. Please try again.\n"
        get_move(turn)
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
