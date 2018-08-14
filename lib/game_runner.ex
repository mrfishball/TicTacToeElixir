defmodule GameRunner do

  def main(_args \\ []) do
    new_game()
  end

  def new_game do
    game_menu()
    |> start()
  end
end
