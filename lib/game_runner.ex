defmodule GameRunner do

  def main(_args \\ []) do
    start()
  end

  def start do
    GameMaker.show_game_menu()
    |> GameMaker.assemble_game()
    |> TTT.play()
  end
end
