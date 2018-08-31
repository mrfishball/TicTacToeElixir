defmodule TTT.Core.GameMaker do
  alias TTT.Core.Player, as: Player
  alias TTT.Core.Game, as: Game
  alias TTT.Console.Board, as: Board
  alias TTT.Utilities.InputValidators, as: InputValidators
  alias TTT.Utilities.TokenPaddingGenerator, as: TokenPaddingGenerator
  require Integer

  @moduledoc """
    The module is responsible for setting up players and putting together
    the essential pieces for the game to run.
  """

  @doc """

    ## Parametrs

      - players: Tuple of player structs which contains players'names, tokens and types.
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

    ##Parameters

      - players: Tuple of player structs which contains player's name, token and type.

    Reset player 2's token if it's identical to player 1's.
    Determined and apply paddings for the shorter token.
    Generate paddings for the initial board when game starts.

    Returns tuple of players with updated, unique tokens, paddings for both sides and the longer token.
  """
  def polish_tokens_and_paddings({player_one, player_two} = players) do
    longer_token = Player.get_longer_token(players)
    players = TokenPaddingGenerator.add_paddings(longer_token, {player_one, player_two})
    paddings = TokenPaddingGenerator.generate_paddings(longer_token, " ")
    {players, paddings, longer_token}
  end

  @doc """

    ##Parameters

      - player_name: String of player's name
      - player_token: String of player's token
      - player_type: function to be called to create the player struct

      Returns a player struct of the type passed in.
  """
  def setup_player(player_name, player_token, player_type) do
    player_type.({player_name, player_token})
  end

  @doc """

    ##Parameters

      - name: String of player's name

      Returns tuple of the result of the validation and the original payload.
  """
  def check_player_name(name) do
    case !InputValidators.empty_input?(name) do
      true -> {:ok, name}
      false -> {:error, name}
    end
  end

  @doc """

    ##Parameters

      - name: String of player's token

      Returns tuple of the result of the validation and the original payload.
  """
  def check_player_symbol(token) do
    case !InputValidators.empty_input?(token) do
      true -> {:ok, token}

      false -> {:error, token}
    end
  end

  defp check_identical_symbol(token_one, token_two) when token_one == token_two do
    {:error, token_two}
  end

  defp check_identical_symbol(token_one, token_two) when token_one != token_two do
    {:ok, token_two}
  end
end
