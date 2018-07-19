defmodule TTT do
  @moduledoc false

  def main(_args \\ []) do
    new()
  end

  def new do
    IO.puts "Let's play Tic Tac Toe!"
    board = Board.new
    game = Game.new
    status = Game.status(game)
    Board.print(board)
    play(board, game, status, :x)
  end

  def play(board, game, status, turn) when status == :underway do
    input = get_input(turn)
    move = match_input(String.trim(input))
    with {:ok, game} <- Game.play_turn(game, turn, move) do
      update_visual(board, game, turn)
      status = Game.status(game)
      turn = switch_turn(turn)
      play(board, game, status, turn)
    else
      {:error, error} -> IO.puts "\nInvalid move: #{error}. Please try again. \n"
      play(board, game, status, turn)
    end
  end

  def play(_board, _game, {_progress, {outcome, person}} = status, _turn) when status != :underway do
    IO.puts "Game over!"
    IO.puts "#{outcome} is #{person}!"
  end

  def play(_board, _game, {_progress, outcome} = status, _turn) when status != :underway do
    IO.puts "Game over!"
    IO.puts "It's a #{outcome}!"
  end

  def switch_turn(last_player) do
    if last_player == :x do
      :o
    else
      :x
    end
  end

  def valid_input?(input) do
    Regex.match?(~r/^[1-9]{1}$/, String.trim(input))
  end

  def get_input(turn) do
    move = IO.gets "'#{turn}', please enter a number from 1 to 9 only: "
    case not valid_input?(move) do
      true ->
        IO.puts "\nInvalid move. Please try again.\n"
        get_input(turn)
      false -> move
    end
  end

  def match_input(move) do
    cond do
      move == "1" -> {0, 0}
      move == "2" -> {1, 0}
      move == "3" -> {2, 0}
      move == "4" -> {0, 1}
      move == "5" -> {1, 1}
      move == "6" -> {2, 1}
      move == "7" -> {0, 2}
      move == "8" -> {1, 2}
      move == "9" -> {2, 2}
    end
  end

  def update_visual(board, game, turn) do
    moves = MapSet.to_list(game.turns[turn])
    oppoents_moves = MapSet.to_list(game.turns[switch_turn(turn)])
    Board.update(board, moves, oppoents_moves, turn, switch_turn(turn))
  end
end
