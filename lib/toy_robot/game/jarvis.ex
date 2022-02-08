defmodule ToyRobot.Game.Jarvis do
  use DynamicSupervisor

  alias ToyRobot.Robot
  alias ToyRobot.Game.Player

  def start_link(initial) do
    DynamicSupervisor.start_link(__MODULE__, initial, name: __MODULE__)
  end

  @spec start_child(identifier :: String.t(), state :: Robot.t()) ::
          DynamicSupervisor.on_start_child()
  def start_child(identifier, state) do
    DynamicSupervisor.start_child(__MODULE__, {Player, [name: identifier, robot: state]})
  end

  def move(identifier) do
    identifier |> Player.process_name() |> Player.move()
  end

  def report(identifier) do
    identifier |> Player.process_name() |> Player.report()
  end

  @doc false
  @impl true
  def init(_) do
    Registry.start_link(keys: :unique, name: Registry.Player)
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
