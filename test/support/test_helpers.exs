defmodule TestHelpers do
  alias TTT.Core.Game, as: Game
  alias TTT.Core.Logic, as: Logic

  def simulate_moves(game, turn, moves, step) when step < length(moves) do
    {:ok, game} = Game.play_turn(game, turn, Enum.at(moves, step))
    turn = Logic.switch_turn(game, turn.token)
    step = step + 1
    simulate_moves(game, turn, moves, step)
  end

  def simulate_moves(game, _turn, moves, step) when step >= length(moves) do
    game
  end
end
