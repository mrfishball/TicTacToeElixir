defmodule PlayerTest do
  use ExUnit.Case

  test "Player struct is correctly created" do
    name = "Steven"
    token = :x
    type = :human
    assert Player.setup(name, token, type) ==
      %Player{name: "Steven", token: :x, type: :human}
  end
end
