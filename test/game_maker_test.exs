defmodule GameMakerTest do
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


end
