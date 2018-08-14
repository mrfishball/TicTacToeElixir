defmodule TTT do
  alias TTT.Console.IO, as: ConsoleIO
  alias TTT.Console.Board, as: Board

  def make_a_play(board, game, _status, %Player{type: :human} = turn) do
      turn
      |> get_move_input()
      |> match_input()
      |> make_a_move(board, game, turn)
  end

  def make_a_play(board, game, _status, %Player{type: :naive_computer} = turn) do
      game
      |> generate_naive_move(1)
      |> make_a_move(board, game, turn)
  end

  def make_a_play(board, game, _status, %Player{type: :random_computer} = turn) do
      game
      |> generate_random_move()
      |> make_a_move(board, game, turn)
  end

  def play({board, game, status, turn})
    when status == :underway do
      make_a_play(board, game, status, turn)
  end

  def play({_board, _game, {_progress, {outcome, winner}} = status, _turn}) when status != :underway do
    ConsoleIO.output(Messages.game_status(outcome, winner), MessageFlags.status)
  end

  def play({_board, _game, {_progress, outcome} = status, _turn}) when status != :underway do
    ConsoleIO.output(Messages.game_status(outcome), MessageFlags.status)
  end

  def make_a_move(move, board, game, %Player{token: token} = turn) do
    with {:ok, game} <- Game.play_turn(game, turn, move) do
      update_visual(board, game)
      status = Game.status(game)
      turn = switch_turn(game, token)
      play({board, game, status, turn})
    else
      {:error, error} -> ConsoleIO.output(Messages.invalid_move(error), MessageFlags.error)
      status = Game.status(game)
      play({board, game, status, turn})
    end
  end

  def generate_naive_move(%Game{players: %{player_one: player_one,
                                           player_two: player_two}} = game, starting_move) do
    move = match_input(starting_move)
    cond do
      MapSet.member?(game.turns[player_one.token], move) or
        MapSet.member?(game.turns[player_two.token], move) ->
          starting_move = starting_move + 1
          generate_naive_move(game, starting_move)
      true ->
        move
    end
  end

  def generate_random_move(%Game{players: %{player_one: player_one,
                                            player_two: player_two}} = game) do
    random_input = :rand.uniform(9)
    move = match_input(random_input)
    cond do
      MapSet.member?(game.turns[player_one.token], move) or
        MapSet.member?(game.turns[player_two.token], move) ->
          generate_random_move(game)
      true ->
        move
    end
  end

  def switch_turn(%Game{players: %{player_one: player_one,
                                   player_two: player_two}}, last_player) do
    if last_player == player_one.token do
      player_two
    else
      player_one
    end
  end

  def valid_input?(input) do
    Regex.match?(~r/^[1-9]{1}$/, String.trim(input))
  end

  def get_move_input(%Player{name: name, token: token} = payload) do
    move = ConsoleIO.input(Messages.make_a_move(name, token), MessageFlags.request)
    case valid_input?(move) do
      true -> String.to_integer(String.trim(move))
      false ->
        ConsoleIO.output(Messages.invalid_move, MessageFlags.error)
        get_move_input(payload)
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

  def update_visual(board, %Game{players: %{player_one: player_one,
                                            player_two: player_two},
                                            token_length: token_length} = game) do
    player_one_moves = MapSet.to_list(game.turns[player_one.token])
    player_two_moves = MapSet.to_list(game.turns[player_two.token])
    moves = %{player_one: {player_one.token, player_one_moves}, player_two: {player_two.token, player_two_moves}}
    Board.render(board, moves, token_length)
  end
end
