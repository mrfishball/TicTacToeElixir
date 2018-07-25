defmodule SetupTest do
  use ExUnit.Case

  test "A string with only whitespaces is not a valid name" do
    name = " "
    name2 = "  "
    name3 = "   "
    assert Setup.valid_name?(String.trim(name)) == false
    assert Setup.valid_name?(String.trim(name2)) == false
    assert Setup.valid_name?(String.trim(name3)) == false
  end

  test "An empty string is not a valid name" do
    name = ""
    assert Setup.valid_name?(name) == false
  end

  test "A string with any number of characters is a valid name" do
    name = "a"
    name2 = "abc"
    name3 = "123"
    name4 = "%$#!**(:>/__-=+"
    assert Setup.valid_name?(name) == true
    assert Setup.valid_name?(name2) == true
    assert Setup.valid_name?(name3) == true
    assert Setup.valid_name?(name4) == true
  end

  test "A string that's a combination of characters and whitespaces is a valid name" do
    name = " abc"
    name2 = "zzz  "
    name3 = "  ggtth*&^$$#)    "
    assert Setup.valid_name?(String.trim(name)) == true
    assert Setup.valid_name?(String.trim(name2)) == true
    assert Setup.valid_name?(String.trim(name3)) == true
  end

  test "Computer player will always take the next open spot following opponent's move if there are no preceding spots" do
    p1 = Player.setup("Steven", :x, :human)
    p2 = Player.setup("Comp", :o, :computer)
    game = Game.setup(p1, p2)

    {:ok, game} = Game.play_turn(game, :x, {0, 0})

    assert TTT.generate_naive_move(game, 1) == {1, 0}
  end

  test "Computer player will always take the first available spot preceding the opponent's move" do
    p1 = Player.setup("Steven", :x, :human)
    p2 = Player.setup("Comp", :o, :computer)
    game = Game.setup(p1, p2)

    {:ok, game} = Game.play_turn(game, :x, {2, 0})

    assert TTT.generate_naive_move(game, 1) == {0, 0}
  end

  test "Correct computer type is returned when user enters a valid input" do
    assert Setup.choose_comp_type("1") == :naive_comp
    assert Setup.choose_comp_type("2") == :random_comp
  end
end
