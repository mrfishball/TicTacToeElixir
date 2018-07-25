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

  test "Correct computer type is returned when user enters a valid input" do
    computer1_name = "Naive computer"
    computer1_token = :x
    computer2_name = "Random computer"
    computer2_token = :o
    assert Setup.choose_computer_type("1", computer1_name, computer1_token) ==
      %Player{name: "Naive computer", token: :x, type: :naive_computer}
    assert Setup.choose_computer_type("2", computer2_name, computer2_token) ==
      %Player{name: "Random computer", token: :o, type: :random_computer}
  end
end
