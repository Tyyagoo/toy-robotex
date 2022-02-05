defmodule ToyRobot.Simulation do
  alias __MODULE__
  alias ToyRobot.{Robot, Table}

  defstruct [:table, :robot]

  @type t :: %__MODULE__{table: Table.t(), robot: Robot.t()}

  @doc """
  Simulates placing a robot on a table.
  
  ## Examples
  
  When the robot is placed in a valid position:
  
    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> Simulation.place(table, %{x: 1, y: 4, facing: :south})
    {
      :ok,
      %Simulation{
      table: table,
      robot: %Robot{x: 1, y: 4, facing: :south}
      }
    }
  
  When the robot is placed in an invalid position:
  
    iex> alias ToyRobot.{Table, Simulation}
    [ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> Simulation.place(table, %{x: 6, y: 0, facing: :north})
    {:error, :invalid_placement}
  
  When the placement map isn't valid:
  
    iex> alias ToyRobot.{Table, Simulation}
    [ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> Simulation.place(table, %{z: 3, y: 0, facing: :north})
    {:error, :invalid_placement_map}
  
  """
  @spec place(table :: Table.t(), placement :: map()) ::
          {:ok, t()} | {:error, reason :: atom()}
  def place(table, %{x: x, y: y, facing: facing}) do
    if Table.valid_position?(table, x, y) do
      {:ok, %Simulation{table: table, robot: Robot.new(x, y, facing)}}
    else
      {:error, :invalid_placement}
    end
  end

  def place(_, _) do
    {:error, :invalid_placement_map}
  end

  @doc """
  Moves the robot forward one space in the direction that it is facing, unless that position is past the bou\
  ndaries of the table.
  
  ## Examples
  
  ### A valid movement
  
    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> simulation = %Simulation{
    ...> table: table,
    ...> robot: %Robot{x: 0, y: 0, facing: :north}
    ...> }
    iex> simulation |> Simulation.move
    {
      :ok,
      %Simulation{
        table: table,
        robot: %Robot{x: 0, y: 1, facing: :north}
      }
    }
  
  ### An invalid movement:
  
    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> simulation = %Simulation{
    ...> table: table,
    ...> robot: %Robot{x: 0, y: 4, facing: :north}
    ...> }
    iex> simulation |> Simulation.move()
    {:error, :at_table_boundary}
  """
  @spec move(simulation :: t()) :: {:ok, t()} | {:error, reason :: atom()}
  def move(%Simulation{robot: robot, table: table} = simulation) do
    with moved_robot <- robot |> Robot.move(),
         true <- table |> Table.valid_position?(moved_robot.x, moved_robot.y) do
      {:ok, %Simulation{simulation | robot: moved_robot}}
    else
      false -> {:error, :at_table_boundary}
    end
  end

  @doc """
  Turns the robot left.
  
  ## Examples
  
    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> simulation = %Simulation{
    ...> table: table,
    ...> robot: %Robot{x: 0, y: 0, facing: :north}
    ...> }
    iex> simulation |> Simulation.turn_left
    {
      :ok,
      %Simulation{
        table: table,
        robot: %Robot{x: 0, y: 0, facing: :west}
      }
    }
  """
  @spec turn_left(simulation :: t()) :: {:ok, t()}
  def turn_left(%Simulation{robot: robot} = simulation) do
    {:ok, %Simulation{simulation | robot: robot |> Robot.rotate(:left)}}
  end

  @doc """
  Turns the robot right.
  
  ## Examples
  
    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> simulation = %Simulation{
    ...> table: table,
    ...> robot: %Robot{x: 0, y: 0, facing: :north}
    ...> }
    iex> simulation |> Simulation.turn_right
    {
      :ok,
      %Simulation{
        table: table,
        robot: %Robot{x: 0, y: 0, facing: :east}
      }
    }
  """
  @spec turn_right(simulation :: t()) :: {:ok, t()}
  def turn_right(%Simulation{robot: robot} = simulation) do
    {:ok, %{simulation | robot: robot |> Robot.rotate(:right)}}
  end

  @doc """
  Returns the robot's current position.
  
  ## Examples
  
    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> simulation = %Simulation{
    ...> table: table,
    ...> robot: %Robot{x: 0, y: 0, facing: :north}
    ...> }
    iex> simulation |> Simulation.report
    %Robot{x: 0, y: 0, facing: :north}
  """
  @spec report(simulation :: t()) :: Robot.t()
  def report(%Simulation{robot: robot}), do: robot
end
