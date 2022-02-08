defmodule ToyRobot.Game.Player do
  use GenServer
  alias ToyRobot.{Robot}

  @spec start(robot :: Robot.t()) :: GenServer.on_start()
  def start(robot) do
    GenServer.start(__MODULE__, robot)
  end

  @spec start_link([{:name, String.t()} | {:robot, Robot.t()}]) :: GenServer.on_start()
  def start_link(name: id, robot: rb) do
    GenServer.start_link(__MODULE__, rb, name: process_name(id))
  end

  @spec init(robot :: Robot.t()) :: {:ok, Robot.t()}
  def init(robot) do
    {:ok, robot}
  end

  @spec move(player :: pid()) :: :ok
  def move(player) do
    GenServer.cast(player, :move)
  end

  @spec turn_left(player :: pid()) :: :ok
  def turn_left(player) do
    GenServer.cast(player, :turn_left)
  end

  @spec turn_right(player :: pid()) :: :ok
  def turn_right(player) do
    GenServer.cast(player, :turn_right)
  end

  @spec report(player :: pid()) :: term()
  def report(player) do
    GenServer.call(player, :report)
  end

  @doc false
  def handle_call(:report, _from, robot) do
    {:reply, robot, robot}
  end

  @doc false
  def handle_cast(:move, robot) do
    {:noreply, robot |> Robot.move()}
  end

  @doc false
  def handle_cast(:turn_left, robot) do
    {:noreply, robot |> Robot.rotate(:left)}
  end

  @doc false
  def handle_cast(:turn_right, robot) do
    {:noreply, robot |> Robot.rotate(:right)}
  end

  def process_name(name) do
    {:via, Registry, {Registry.Player, name}}
  end
end
