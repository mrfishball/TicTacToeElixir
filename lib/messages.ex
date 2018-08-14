defmodule Messages do

  def title do
    "Let's play Tic Tac Toe!\n\n"
  end

  def select do
    "Your choice is "
  end

  def player_name(player_number) do
    "What is your name? (Player #{player_number}): "
  end

  def player_symbol(player_name) do
    "What do you want your token to be, #{player_name}?: "
  end

  def game_status(outcome) do
    "Game over!\nIt's a #{outcome}!"
  end

  def game_status(outcome, winner) do
    "Game over!\nThe #{outcome} is #{winner}!"
  end

  def make_a_move(name, token) do
    "#{name} - '#{String.trim(token)}', please enter a number from 1 to 9 only: "
  end

  def invalid_move(error) do
    "\nInvalid move: #{error}. Please try again. \n"
  end

  def invalid_move do
    "\nInvalid move. Please try again.\n"
  end

  def invalid_entry do
    "\nInvalid entry. Please try again.\n"
  end

  def token_take(token) do
    "\nToken '#{token}' is taken. Please choose a different token.\n"
  end

  def symbol_taken_error(token) do
    {@error, "\n The token '#{token}' is taken. Please enter a different token: "}
  end

  def game_menu do
    "Let's play Tic Tac Toe!\n\n" <>
    "Select a game mode (Enter a number from 1 to 3)\n\n" <>
    "1. Player vs. Player\n" <>
    "2. Player vs. Computer\n" <>
    "3. Spectate a game\n"
  end

  def computer_choice_menu(computer_name) do
    "\nChoose the type of the computer player for #{computer_name} (Enter a number from 1 to 2)\n\n" <>
    "1. Naive - (#{computer_name} will take the first available spot)\n" <>
    "2. Random - (#{computer_name} will take an available spot randomly)\n"
  end
end
