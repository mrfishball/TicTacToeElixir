defmodule GameRunner do
  alias TTT.Console.Board, as: Board

  def main(_args \\ []) do
    new_game()
  end

  def new_game do
    GameMaker.game_menu()
    |> start()
  end

  def start({player_one, _player_two} = players) do
    player_two = GameMaker.reset_symbol_if_identical(players)
    players = {player_one, player_two}

    longest_token_player = GameMaker.longest_token_player(players)
    {player_one, player_two} = GameMaker.add_paddings(longest_token_player, players)
    {left_pad, right_pad} = GameMaker.symbol_paddings(longest_token_player.token, " ")

    game = Game.new_game(player_one, player_two, String.length(longest_token_player.token))
    board = Board.new_board(left_pad, right_pad)
    status = Game.status(game)
    Board.show(board, game.token_length)

    TTT.play(board, game, status, player_one)
  end
end
