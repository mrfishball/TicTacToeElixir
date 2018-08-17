defmodule GameMaker do
  alias TTT.Console.Board, as: Board
  alias TTT.Utilities.InputValidators, as: InputValidators
  alias TTT.Utilities.TokenPaddingGenerator, as: TokenPaddingGenerator
  require Integer

  @moduledoc """
    The module is responsible for setting up plaers and putting together
    the essential pieces for the game to run.
  """

  @doc """

    ## Parametrs

      - players: Tuple of player structs which contains player's name, token and type.
      - paddings: Tuple consists of left padding and right padding(whitespaces).
      - longer_token: String of the longer token.


    Assembles and returns a tuple of game components.
  """
  def assemble_game({{player_one, _player_two} = players, paddings, longer_token}) do

    game = Game.new_game(players, String.length(longer_token))
    status = Game.status(game)
    board = Board.new_board(paddings)
    Board.show_board(board, game.token_length)

    {board, game, status, player_one}
  end

  @doc """

    ## Parametrs

      - players: Tuple of player structs which contains player's name, token and type.

    Reset player 2's token if it's identical to player 1's.
    Determined and apply paddings for the shorter token.
    Generate paddings for the initial board when game starts.

    Returns tuple of players with updated, unique tokens, paddings for both sides and the longer token.
  """
  def polish_tokens_and_paddings({player_one, _player_two} = players) do
    player_two = reset_symbol_if_identical(players)
    longer_token = Player.get_longer_token(players)
    players = TokenPaddingGenerator.add_paddings(longer_token, {player_one, player_two})
    paddings = TokenPaddingGenerator.generate_paddings(longer_token, " ")
    {players, paddings, longer_token}
  end

  @doc """

    This represents the human vs human game mode. It assembles the
    players and returns them in a tuple.
  """
  def player_vs_player do
    player_one = set_human_player(1)
    player_two = set_human_player(2)
    {player_one, player_two}
  end

  @doc """

    This represents the human vs computer game mode. It assembles the
    players and returns them in a tuple.
  """
  def player_vs_computer do
    player_one = set_human_player(1)
    player_two = set_computer_player(2)
    {player_one, player_two}
  end

  @doc """

    This represents the computer vs computer game mode. It assembles the
    players and returns them in a tuple.
  """
  def computer_vs_computer do
    player_one = set_computer_player(1)
    player_two = set_computer_player(2)
    {player_one, player_two}
  end

  @doc """

    ## Parametrs

      - players: Tuple of player structs which contains player's name, token and type.

    Checks if two players have the same token, if true, it'll reset the second player's token.
    Returns a struct of player two.
  """
  def reset_symbol_if_identical({player_one, player_two}) do
    cond do
      player_one.token == player_two.token ->
        IOcontroller.output(Messages.token_take(player_two.token), MessageFlags.error)
        {_player_two_name, new_token} = set_player_symbol(player_two.name)
        player_two = %Player{player_two | token: new_token}
        reset_symbol_if_identical({player_one, player_two})
      true ->
        player_two
    end
  end

  defp set_human_player(player_number) do
    player_number
    |> set_player_name()
    |> set_player_symbol()
    |> Player.human()
  end

  defp set_computer_player(player_number) do
    player_number
    |> set_player_name()
    |> set_player_symbol()
    |> computer_type_selection()
  end

  defp computer_type_selection({computer_name, _token} = payload) do
      IOcontroller.output(Messages.computer_choice_menu(computer_name), MessageFlags.menu)
      Messages.select()
      |> IOcontroller.input(MessageFlags.request)
      |> make_computer_player(payload)
  end

  defp make_computer_player(choice, payload) do
    cond do
      choice == "1" -> Player.naive_computer(payload)
      choice == "2" -> Player.random_computer(payload)
      true ->
        IOcontroller.output(Messages.invalid_entry, MessageFlags.error)
        computer_type_selection(payload)
    end
  end

  defp set_player_name(player_number) do
    input = IOcontroller.input(Messages.player_name(player_number), MessageFlags.request)
    case !InputValidators.empty_input?(input) do
      true -> input
      false ->
        IOcontroller.output(Messages.invalid_entry, MessageFlags.error)
        set_player_name(player_number)
    end
  end

  defp set_player_symbol(player_name) do
    input = IOcontroller.input(Messages.player_symbol(player_name), MessageFlags.request)
    case !InputValidators.empty_input?(input) do
      true -> {player_name, input}
      false ->
        IOcontroller.output(Messages.invalid_entry, MessageFlags.error)
        set_player_symbol(player_name)
    end
  end
end
