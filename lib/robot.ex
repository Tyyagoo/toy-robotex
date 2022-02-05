defmodule ToyRobot.Robot do
  alias __MODULE__
  alias ToyRobot.Cardinal

  defstruct x: 0, y: 0, facing: :north

  @typedoc """
      Type that represents Robot struct with :x as integer, :y as integer and :facing as Cardinal.t()
  """
  @type t :: %Robot{x: integer(), y: integer(), facing: Cardinal.t()}

  @doc """
  Create a new robot.

  ## Examples
    iex> alias ToyRobot.Robot
    ToyRobot.Robot
    iex> Robot.new()
    %Robot{x: 0, y: 0, facing: :north}
  """
  @spec new() :: t()
  def new(), do: %Robot{}

  @doc """
  Moves the robot foward by one space, ignores if robot is on table limit.

  ## Examples
    iex> alias ToyRobot.Robot
    ToyRobot.Robot
    iex> robot = Robot.new()
    %Robot{x: 0, y: 0, facing: :north}
    iex> 1..10 |> Enum.reduce(robot, fn _, r -> Robot.move(r) end)
    %Robot{x: 0, y: 6, facing: :north}
  """
  @spec move(robot :: t()) :: t()
  def move(%Robot{facing: facing} = robot) do
    case facing do
      :north -> %Robot{robot | y: min(robot.y + 1, 6)}
      :south -> %Robot{robot | y: max(robot.y - 1, 0)}
      :east -> %Robot{robot | x: min(robot.x + 1, 6)}
      :west -> %Robot{robot | x: max(robot.x - 1, 0)}
      _ -> robot
    end
  end

  @doc """
  Rotates the robot by |90| degrees according to desired direction.
  If the direction is invalid, nothing is done.

  ## Examples
    iex> alias ToyRobot.Robot
    ToyRobot.Robot
    iex> robot = Robot.new()
    %Robot{x: 0, y: 0, facing: :north}
    iex> robot = robot |> Robot.rotate(:right)
    %Robot{x: 0, y: 0, facing: :east}
    iex> robot |> Robot.rotate(:left)
    %Robot{x: 0, y: 0, facing: :north}
  """
  @spec rotate(robot :: t(), dir :: :left | :right) :: t()
  def rotate(robot, dir) do
    case dir do
      :left -> rotate_left(robot)
      :right -> rotate_right(robot)
      _ -> robot
    end
  end

  defp rotate_left(robot) do
    case Cardinal.turn(robot.facing, :anticlockwise) do
      {:ok, dir} -> %Robot{robot | facing: dir}
      _ -> robot
    end
  end

  defp rotate_right(robot) do
    case Cardinal.turn(robot.facing, :clockwise) do
      {:ok, dir} -> %Robot{robot | facing: dir}
      _ -> robot
    end
  end

  @doc """
  Compares if two robots are deeply equal.

  ## Examples
    iex> alias ToyRobot.Robot
    ToyRobot.Robot
    iex> rob1 = Robot.new()
    %Robot{x: 0, y: 0, facing: :north}
    iex> rob2 = Robot.new()
    %Robot{x: 0, y: 0, facing: :north}
    iex> Robot.equals(rob1, rob2)
    true
    iex> rob1 |> Robot.rotate(:left) |> Robot.equals(rob2)
    false
  """
  @spec equals(robot :: t(), other :: t()) :: boolean()
  def equals(robot, robot), do: true
  def equals(_, _), do: false
end
