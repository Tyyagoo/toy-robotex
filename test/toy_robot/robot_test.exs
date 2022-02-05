defmodule ToyRobot.RobotTest do
  use ExUnit.Case, async: true
  doctest ToyRobot.Robot

  alias ToyRobot.Robot

  describe "when the robot is facing north" do
    setup do
      %{robot: Robot.new()}
    end

    test "it moves only one space to north", %{robot: robot} do
      robot = robot |> Robot.move()
      assert robot.y == 1
    end

    test "it must walk how many times was asked", %{robot: robot} do
      robot = 1..100 |> Enum.reduce(robot, fn _, acc -> acc |> Robot.move() end)
      assert robot.y == 100
    end
  end

  describe "when walking in circles" do
    setup do
      %{robot: Robot.new()}
    end

    test "it must return to initial position when rotating by right", %{robot: robot} do
      [
        {&(&1 |> Robot.move()), %Robot{x: 0, y: 1, facing: :north}},
        {&(&1 |> Robot.rotate(:right) |> Robot.move()), %Robot{x: 1, y: 1, facing: :east}},
        {&(&1 |> Robot.rotate(:right) |> Robot.move()), %Robot{x: 1, y: 0, facing: :south}},
        {&(&1 |> Robot.rotate(:right) |> Robot.move()), %Robot{x: 0, y: 0, facing: :west}}
      ]
      |> Enum.reduce(robot, fn {fun, exp}, acc ->
        acc
        |> fun.()
        |> Kernel.tap(fn actual -> assert Robot.equals(actual, exp) end)
      end)
    end

    test "it must return to initial position when rotating by left", %{robot: robot} do
      [
        {&(&1 |> Robot.rotate(:left)), %Robot{x: 0, y: 0, facing: :west}},
        {&(&1 |> Robot.rotate(:left)), %Robot{x: 0, y: 0, facing: :south}},
        {&(&1 |> Robot.rotate(:left)), %Robot{x: 0, y: 0, facing: :east}},
        {&(&1 |> Robot.move()), %Robot{x: 1, y: 0, facing: :east}},
        {&(&1 |> Robot.rotate(:left)), %Robot{x: 1, y: 0, facing: :north}},
        {&(&1 |> Robot.move()), %Robot{x: 1, y: 1, facing: :north}},
        {&(&1 |> Robot.rotate(:left)), %Robot{x: 1, y: 1, facing: :west}},
        {&(&1 |> Robot.move()), %Robot{x: 0, y: 1, facing: :west}},
        {&(&1 |> Robot.rotate(:left)), %Robot{x: 0, y: 1, facing: :south}},
        {&(&1 |> Robot.move()), %Robot{x: 0, y: 0, facing: :south}}
      ]
      |> Enum.reduce(robot, fn {fun, exp}, acc ->
        acc
        |> fun.()
        |> Kernel.tap(fn actual -> assert Robot.equals(actual, exp) end)
      end)
    end
  end

  describe "when receiving a list of movement commands" do
    setup do
      %{robot: Robot.new()}
    end

    test "it must ends in the correct position (3, 3, east)", %{robot: robot} do
      robot =
        robot
        |> Robot.move()
        |> Robot.rotate(:right)
        |> Robot.move()
        |> Robot.rotate(:left)
        |> Robot.move()
        |> Robot.move()
        |> Robot.rotate(:left)
        |> Robot.move()
        |> Robot.rotate(:right)
        |> Robot.rotate(:right)
        |> Robot.move()
        |> Robot.move()
        |> Robot.move()

      assert %{x: 3, y: 3, facing: :east} = robot
    end
  end
end
