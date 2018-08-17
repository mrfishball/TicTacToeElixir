defmodule TTT do
  alias TTT.Console.Board, as: Board
  alias TTT.Utilities.InputValidators, as: InputValidators
  alias TTT.Utilities.InputParser, as: InputParser

  @moduledoc """
    This module represents the game play logic.
  """

  @doc """

    ## Parameters

      - {board, game, status, turn}: Tuple of game components.
        - turn: the player in turn.

    Checks the status of the game to make sure it's still ongoing before making a play.
  """
  def play({board, game, status, turn})
    when status == :underway do
      make_a_play(board, game, status, turn)
  end

  @doc """

    If the game ends in a win, it'll display a message with the result and the winner.
  """
  def play({_board, _game, {_progress, {outcome, winner}} = status, _turn}) when status != :underway do
    IOcontroller.output(Messages.game_status(outcome, winner), MessageTags.status)
  end

  @doc """

    If the game ends in a draw, it'll display a message with the result.
  """
  def play({_board, _game, {_progress, outcome} = status, _turn}) when status != :underway do
    IOcontroller.output(Messages.game_status(outcome), MessageTags.status)
  end

  @doc """

    If the game end in a win, it'll display a message with the result and the winner.
  """
  def generate_naive_move(%Game{turns: turns} = game, starting_move) do
    move = InputParser.parse_input(starting_move)
    cond do
      Game.cell_taken?(turns, move) ->
          starting_move = starting_move + 1
          generate_naive_move(game, starting_move)
      true ->
        move
    end
  end

  def generate_random_move(%Game{turns: turns} = game) do
    random_input = :rand.uniform(9)
    move = InputParser.parse_input(random_input)
    cond do
      Game.cell_taken?(turns, move) ->
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

  def update_visual(board, %Game{players: %{player_one: player_one,
                                            player_two: player_two},
                                            token_length: token_length} = game) do
    player_one_moves = MapSet.to_list(game.turns[player_one.token])
    player_two_moves = MapSet.to_list(game.turns[player_two.token])
    moves = %{player_one: {player_one.token, player_one_moves}, player_two: {player_two.token, player_two_moves}}
    Board.render_board(board, moves, token_length)
  end

  defp make_a_move(move, board, game, %Player{token: token} = turn) do
    with {:ok, game} <- Game.play_turn(game, turn, move) do
      update_visual(board, game)
      status = Game.status(game)
      turn = switch_turn(game, token)
      play({board, game, status, turn})
    else
      {:error, error} -> IOcontroller.output(Messages.invalid_move(error), MessageTags.error)
      status = Game.status(game)
      play({board, game, status, turn})
    end
  end

  #### Private function section ####

  defp make_a_play(board, game, _status, %Player{type: :human} = turn) do
      turn
      |> get_move_input()
      |> InputParser.parse_input()
      |> make_a_move(board, game, turn)
  end

  defp make_a_play(board, game, _status, %Player{type: :naive_computer} = turn) do
      game
      |> generate_naive_move(1)
      |> make_a_move(board, game, turn)
  end

  defp make_a_play(board, game, _status, %Player{type: :random_computer} = turn) do
      game
      |> generate_random_move()
      |> make_a_move(board, game, turn)
  end

  defp get_move_input(%Player{name: name, token: token} = payload) do
    move = IOcontroller.input(Messages.make_a_move(name, token), MessageTags.request)
    case InputValidators.valid_move?(move) do
      true -> move
      false ->
        IOcontroller.output(Messages.invalid_move, MessageTags.error)
        get_move_input(payload)
    end
  end
end
