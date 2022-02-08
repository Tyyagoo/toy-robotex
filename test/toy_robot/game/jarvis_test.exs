defmodule ToyRobot.Game.JarvisTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Robot
  alias ToyRobot.Game.Jarvis

  test "starts a player child process" do
    robot = Robot.new()
    {:ok, player} = Jarvis.start_child("Izzy", robot)

    [{registered_player, _}] = Registry.lookup(Registry.Player, "Izzy")
    assert registered_player == player

    %{active: active} = DynamicSupervisor.count_children(Jarvis)
    assert active == 1
  end

  test "starts a registry" do
    registry = Process.whereis(Registry.Player)
    assert registry
  end

  test "moves a robot forward" do
    robot = %Robot{x: 0, y: 0, facing: :north}
    {:ok, _player} = Jarvis.start_child("Charlie", robot)
    %{robot: %{y: y}} = Jarvis.move("Charlie")

    assert y == 1
  end

  test "reports a robot's location" do
    robot = %Robot{x: 0, y: 0, facing: :north}
    {:ok, _player} = Jarvis.start_child("Davros", robot)
    %{y: y} = Jarvis.report("Davros")

    assert y == 0
  end
end
