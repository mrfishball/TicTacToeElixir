defmodule Messages do

  @menu :menu
  @request :request
  @error :error
  @status :status

  def title do
    {@menu, "Let's play Tic Tac Toe!\n\n"}
  end

  def choice do
    {@request, "Your choice is "}
  end

  def player_name(player_number) do
    {@request, "What is your name? (Player #{player_number}): "}
  end

  def player_symbol(player_name) do
    {@request, "What do you want your token to be, #{player_name}?: "}
  end

  def game_status(outcome) do
    {@status, "Game over!\nIt's a #{outcome}!"}
  end

  def game_status(outcome, winner) do
    {@status, "Game over!\nThe #{outcome} is #{winner}!"}
  end

  def make_a_move(name, token) do
    {@request, "#{name} - '#{String.trim(token)}', please enter a number from 1 to 9 only: "}
  end

  def invalid_move(error) do
    {@error, "\nInvalid move: #{error}. Please try again. \n"}
  end

  def invalid_move do
    {@error, "\nInvalid move. Please try again.\n"}
  end

  def invalid_entry do
    {@error, "\nInvalid entry. Please try again.\n"}
  end

  def game_menu do
    {@menu, "Let's play Tic Tac Toe!\n\n" <>
    "Select a game mode (Enter a number from 1 to 3)\n\n" <>
    "1. Player vs. Player\n" <>
    "2. Player vs. Computer\n" <>
    "3. Spectate a game\n"}
  end

  def computer_choice_menu(computer_name) do
    {@menu, "\nChoose the type of the computer player for #{computer_name} (Enter a number from 1 to 2)\n\n" <>
    "1. Naive - (#{computer_name} will take the first available spot)\n" <>
    "2. Random - (#{computer_name} will take an available spot randomly)\n"}
  end
end
