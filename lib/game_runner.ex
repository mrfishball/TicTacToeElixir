defmodule GameRunner do

  def main(_args \\ []) do
    new_game()
  end

  def new_game do
    GameMaker.game_menu()
    |> start()
  end

  def start(players) do
    player = GameMaker.longest_token_player(players)
    {player_one, player_two} = GameMaker.add_paddings(player, players)
    {left_pad, right_pad} = GameMaker.symbol_paddings(player.token, " ")

    game = Game.new_game(player_one, player_two, String.length(player.token))
    board = Board.new_board(left_pad, right_pad)
    status = Game.status(game)
    Board.show(board, String.length(player.token))

    TTT.play(board, game, status, player_one)
  end
end
