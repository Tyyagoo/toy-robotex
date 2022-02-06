defmodule ToyRobot.Command.RunnerTest do
  import ExUnit.CaptureIO
  use ExUnit.Case

  doctest ToyRobot.Command.Runner

  alias ToyRobot.Command.Runner
  alias ToyRobot.Simulation

  test "it must handle a valid place command" do
    %Simulation{robot: robot} =
      [{:place, %{facing: :north, x: 1, y: 2}}]
      |> Runner.run()

    assert robot.x == 1
    assert robot.y == 2
    assert robot.facing == :north
  end

  test "it must handle a invalid place command" do
    simulation =
      [{:place, %{facing: :north, x: 5, y: 4}}]
      |> Runner.run()

    assert simulation == nil
  end

  test "it must ignores commands until a valid placement" do
    %Simulation{robot: robot} =
      [
        :move,
        {:place, %{x: 1, y: 2, facing: :north}}
      ]
      |> Runner.run()

    assert robot.x == 1
    assert robot.y == 2
    assert robot.facing == :north
  end

  test "it must handles a place + move command correctly" do
    %Simulation{robot: robot} =
      [
        {:place, %{x: 1, y: 2, facing: :north}},
        :move
      ]
      |> Runner.run()

    assert robot.x == 1
    assert robot.y == 3
    assert robot.facing == :north
  end

  test "it must handles a place + invalid move command" do
    %Simulation{robot: robot} =
      [
        {:place, %{x: 1, y: 4, facing: :north}},
        :move
      ]
      |> Runner.run()

    assert robot.x == 1
    assert robot.y == 4
    assert robot.facing == :north
  end

  test "it must handles a place + turn_left command" do
    %Simulation{robot: robot} =
      [
        {:place, %{x: 1, y: 2, facing: :north}},
        :turn_left
      ]
      |> Runner.run()

    assert robot.x == 1
    assert robot.y == 2
    assert robot.facing == :west
  end

  test "handles a place + turn_right command" do
    %Simulation{robot: robot} =
      [
        {:place, %{x: 1, y: 2, facing: :north}},
        :turn_right
      ]
      |> Runner.run()

    assert robot.x == 1
    assert robot.y == 2
    assert robot.facing == :east
  end

  test "handles a place + report command" do
    commands = [
      {:place, %{x: 1, y: 2, facing: :north}},
      :report
    ]

    output =
      capture_io(fn ->
        Runner.run(commands)
      end)

    assert output |> String.trim() == "The robot is at (1, 2) and is facing NORTH"
  end

  test "handles a place + invalid command" do
    %Simulation{robot: robot} =
      [
        {:place, %{x: 1, y: 2, facing: :north}},
        {:invalid, "EXTERMINATE"}
      ]
      |> Runner.run()

    assert robot.x == 1
    assert robot.y == 2
    assert robot.facing == :north
  end

  describe "when robot is trying to move outside boundaries" do
    test "it must ignore the command when facing north" do
      %Simulation{robot: robot} =
        [
          {:place, %{x: 0, y: 4, facing: :north}},
          :move
        ]
        |> Runner.run()

      assert robot.y == 4
    end

    test "it must ignore the command when facing east" do
      %Simulation{robot: robot} =
        [
          {:place, %{x: 4, y: 0, facing: :east}},
          :move
        ]
        |> Runner.run()

      assert robot.x == 4
    end

    test "it must ignore the command when facing south" do
      %Simulation{robot: robot} =
        [
          {:place, %{x: 0, y: 0, facing: :south}},
          :move
        ]
        |> Runner.run()

      assert robot.y == 0
    end

    test "it must ignore the command when facing west" do
      %Simulation{robot: robot} =
        [
          {:place, %{x: 0, y: 0, facing: :west}},
          :move
        ]
        |> Runner.run()

      assert robot.x == 0
    end
  end
end
