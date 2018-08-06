defmodule Messages do

  @enforce_keys [:title, :choice, :error, :game_menu, :computer_choice_menu]
  defstruct @enforce_keys

  def new_messages do
    game_menu = game_menu()
    computer_choice_menu = computer_choice_menu()
    %Messages{title: "Let's play Tic Tac Toe!\n\n",
             choice: "Your choice is ",
              error: "\nInvalid entry. Please try again.\n",
          game_menu: game_menu,
          computer_choice_menu: computer_choice_menu}
  end

  defp game_menu do
    "Let's play Tic Tac Toe!\n\n" <>
    "Please select a game mode (Enter a number from 1 to 3)\n\n" <>
    "1. Player vs. Player\n" <>
    "2. Player vs. Computer\n" <>
    "3. Spectate a game\n\n"
  end

  defp computer_choice_menu do
    "Please choose the type of the computer player (Enter a number from 1 to 2)\n" <>
    "1. Naive - (Computer player will take the first available spot)\n" <>
    "2. Random - (will take an available spot randomly)\n\n"
  end
end
