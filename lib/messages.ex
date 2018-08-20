defmodule Messages do

  @moduledoc """

    A collection of input and output strings.
  """

  def title do
    "\n\nLet's play Tic Tac Toe!\n"
  end

  def select do
    "Your choice is "
  end

  @doc """

    ## Parameters

      - player_number: Integer that represent the order of the player.

  """
  def player_name(player_number) do
    "What is your name? (Player #{player_number}): "
  end

  def player_symbol(player_number) do
    "What do you want your token to be? (Player #{player_number}): "
  end

  @doc """

    ## Parameters

      - outcome: Atom that represent the outcome of the game.

  """
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

  def invalid_name(name) do
    "\n'#{name}' is not a valid name. Please try again.\n"
  end

  def invalid_token(token) do
    "\n'#{token}' is not a valid token. Please try again.\n"
  end

  def symbol_taken_error(token) do
    "\nToken '#{token}' is taken. Please choose a different token.\n"
  end

  def game_menu do
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
