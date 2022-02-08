defmodule ToyRobot.Game.PlayerTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Game.Player
  alias ToyRobot.Robot

  describe "when using 'single' commands" do
    setup do
      starting_position = %Robot{x: 0, y: 0, facing: :north}
      {:ok, player} = Player.start(starting_position)
      %{player: player}
    end

    test "it must report robot position correctly", %{player: player} do
      assert Player.report(player) == %Robot{
               x: 0,
               y: 0,
               facing: :north
             }
    end

    test "it must move robot and report the position correctly", %{player: player} do
      :ok = Player.move(player)

      assert Player.report(player) == %Robot{
               x: 0,
               y: 1,
               facing: :north
             }
    end

    test "it must turn left robot and report the position correctly", %{player: player} do
      :ok = Player.turn_left(player)

      assert Player.report(player) == %Robot{
               x: 0,
               y: 0,
               facing: :west
             }
    end

    test "it must turn right robot and report the position correctly", %{player: player} do
      :ok = Player.turn_right(player)

      assert Player.report(player) == %Robot{
               x: 0,
               y: 0,
               facing: :east
             }
    end
  end
end
