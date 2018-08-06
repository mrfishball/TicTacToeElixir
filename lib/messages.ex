defmodule Messages do

  def title do
    "Let's play Tic Tac Toe!\n\n"
  end

  def error do
    "\nInvalid entry. Please try again.\n"
  end

  def choice do
    "Your choice is "
  end

  def player_name(player_number) do
    "What is your name? (Player #{player_number}): "
  end

  def player_symbol(player_name) do
    "What do you want your token to be, #{player_name}?: "
  end

  def game_menu do
    "Let's play Tic Tac Toe!\n\n" <>
    "Select a game mode (Enter a number from 1 to 3)\n\n" <>
    "1. Player vs. Player\n" <>
    "2. Player vs. Computer\n" <>
    "3. Spectate a game\n\n"
  end

  def computer_choice_menu(computer_name) do
    "Choose the type of the computer player for #{computer_name} (Enter a number from 1 to 2)\n" <>
    "1. Naive - (#{computer_name} will take the first available spot)\n" <>
    "2. Random - (#{computer_name} will take an available spot randomly)\n\n"
  end
end
