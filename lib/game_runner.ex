defmodule GameRunner do

  def main(_args \\ []) do
    new_game()
  end

  def new_game do
    GameMaker.show_game_menu()
    |> GameMaker.assemble_game()
    |> TTT.play()
  end
end
