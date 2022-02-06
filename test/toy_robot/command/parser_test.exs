defmodule ToyRobot.Command.ParserTest do
  use ExUnit.Case
  doctest ToyRobot.Command.Parser

  alias ToyRobot.Command.Parser

  test "it must handle all commands" do
    commands =
      ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "REPORT"]
      |> Parser.parse()

    assert [
             {:place, %{facing: :north, x: 1, y: 2}},
             :move,
             :turn_left,
             :turn_right,
             :report
           ] = commands
  end

  test "it must ignore invalid commands" do
    commands =
      [
        "",
        "SPIN",
        "TWIRL",
        "RIGHT",
        "move",
        "PLACE",
        "MOVE 10",
        "PLACE 1,2,SOUTI",
        "PLACE a,b,NORTH"
      ]
      |> Parser.parse()

    assert [:turn_right] = commands
  end
end
