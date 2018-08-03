defmodule GameMaker do
  require Integer

  def new_game do
    IO.puts "Let's play Tic Tac Toe!\n"
    game_menu()
    |> start()
  end

  def game_menu do
    color_menu = Colorizer.yellow(
      "Please select a game mode: \n\n1. Player vs. Player\n2. Player vs. Computer\n3. Spectate a game\n\nYour choice is: ")
    input = IO.gets color_menu
    input
    |> String.trim()
    |> game_mode()
  end

  def game_mode(choice) do
    cond do
      choice == "1" -> player_vs_player()
      choice == "2" -> player_vs_computer()
      choice == "3" -> computer_vs_computer()
      true ->
        IO.puts Colorizer.red("\nInvalid entry. Please try again.\n")
        game_menu()
    end
  end

  def start(players) do
    player = longest_token_player(players)
    {player_one, player_two} = add_paddings(player, players)
    {left_pad, right_pad} = symbol_paddings(player.token, " ")

    game = Game.new_game(player_one, player_two, String.length(player.token))
    board = Board.new_board(left_pad, right_pad)
    status = Game.status(game)
    Board.show(board, String.length(player.token))

    TTT.play(board, game, status, player_one)
  end

  def player_vs_player do
    player_one = set_human_player(1)
    player_two = set_human_player(2)
    {player_one, player_two}
  end

  def player_vs_computer do
    player_one = set_human_player(1)
    player_two = set_computer_player(2)
    {player_one, player_two}
  end

  def computer_vs_computer do
    player_one = set_computer_player(1)
    player_two = set_computer_player(2)
    {player_one, player_two}
  end

  def set_human_player(player_number) do
    player_number
    |> set_player_name()
    |> set_player_symbol()
    |> Player.human()
  end

  def set_computer_player(player_number) do
    player_number
    |> set_player_name()
    |> set_player_symbol()
    |> computer_type_menu()
  end

  defp computer_type_menu({computer_name, _token} = payload) do
      IO.puts Colorizer.yellow("Please choose the type of the computer player - '#{computer_name}':\n")
      IO.puts Colorizer.yellow("1. Naive - ('#{computer_name}' will take the first available spot)")
      IO.puts Colorizer.yellow("2. Random - ('#{computer_name}' will take an available spot randomly)\n")
      input = IO.gets Colorizer.yellow("Your choice is (Enter 1 or 2): ")
      input
      |> String.trim()
      |> choose_computer_type(payload)
  end

  defp choose_computer_type(choice, payload) do
    cond do
      choice == "1" -> Player.naive_computer(payload)
      choice == "2" -> Player.random_computer(payload)
      true ->
        IO.puts Colorizer.red("\nInvalid entry. Please try again\n")
        computer_type_menu(payload)
    end
  end

  def set_player_symbol(player_name) do
    input = IO.gets Colorizer.yellow("Enter a symbol for player '#{player_name}: ")
    case valid_symbol?(input) do
      true -> {player_name, String.trim(input)}
      false ->
        IO.puts Colorizer.red("This is not a valid symbol. Please try again.\n")
        set_player_symbol(player_name)
    end
  end

  def add_paddings(player, {player_one, player_two} = _players) do
    cond do
      player != player_one ->
        {left_side, right_side} = symbol_paddings(player.token, player_one.token)
        player_one = %Player{player_one | token: "#{left_side <> player_one.token <> right_side}"}
        {player_one, player_two}
      player != player_two ->
        {left_side, right_side} = symbol_paddings(player.token, player_two.token)
        player_two = %Player{player_two | token: "#{left_side <> player_two.token <> right_side}"}
        {player_one, player_two}
    end
  end

  def symbol_paddings(long_token, short_token) do
    difference = String.length(long_token) - String.length(short_token)
    side = div(difference, 2)
    extra_padding = rem(difference, 2)
    left_side = String.duplicate(" ", side + extra_padding)
    right_side = String.duplicate(" ", side)
    {left_side, right_side}
  end

  def set_player_name(player_number) do
    input = IO.gets Colorizer.yellow("\nPlease enter your name (Player #{player_number}): ")
    name = String.trim(input)
    case valid_name?(name) do
      true -> name
      false ->
        IO.puts Colorizer.red("This is not a valid name. Please try again.\n")
        set_player_name(player_number)
    end
  end

  def longest_token_player({player_one, player_two} = _players) do
    if String.length(player_one.token) >= String.length(player_two.token) do
      player_one
    else
      player_two
    end
  end

  def valid_symbol?(symbol) do
    String.length(String.trim(symbol)) >= 1
  end

  def valid_name?(name) do
    String.trim(name) != ""
  end
end
