defmodule GameMakerTest do
  # alias TTT.Core.Game, as: Game
  alias TTT.Core.Player, as: Player
  alias TTT.Core.GameMaker, as: GameMaker
  use ExUnit.Case

  test "player is setup with the correct type" do
    type = &Player.human/1
    player = GameMaker.setup_player("Steven", "X", type)
    assert player.type == :human
  end

  test "player is setup with the correct name" do
    name = "Steven"
    player = GameMaker.setup_player(name, "O", &Player.human/1)
    assert player.name == "Steven"
  end

  test "player is setup with the correct token" do
    token = "D"
    player = GameMaker.setup_player("Steven", token, &Player.human/1)
    assert player.token == "D"
  end

  test "status of ok with the name are expected to be return for a valid name" do
    assert GameMaker.check_player_name("Steven") == {:ok, "Steven"}
  end

  test "error and with the name are returned if the name is invalid" do
    assert GameMaker.check_player_name(" ") == {:error, " "}
  end

  test "status of ok with the token are expected to be return for a valid token" do
    assert GameMaker.check_player_symbol("X") == {:ok, "X"}
  end

  test "error and with the token are returned if the token is invalid" do
    assert GameMaker.check_player_symbol(" ") == {:error, " "}
  end
end
