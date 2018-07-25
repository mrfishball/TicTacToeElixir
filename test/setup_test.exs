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
    assert Setup.choose_computer_type("1") == :naive_computer
    assert Setup.choose_computer_type("2") == :random_computer
  end
end
