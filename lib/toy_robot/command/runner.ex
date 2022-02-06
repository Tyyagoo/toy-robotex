defmodule ToyRobot.Command.Runner do
  alias ToyRobot.{Table, Simulation, Cardinal}

  def run([{:place, placement} | tail]) do
    Table.new(4, 4)
    |> Simulation.place(placement)
    |> case do
      {:ok, simulation} -> simulation |> do_run(tail)
      {:error, _} -> run(tail)
    end
  end

  def run([_ | tail]), do: run(tail)

  def run([]), do: nil

  defp do_run(simulation, [:move | tail]) do
    simulation
    |> Simulation.move()
    |> case do
      {:ok, new_state} -> new_state |> do_run(tail)
      {:error, _} -> simulation |> do_run(tail)
    end
  end

  defp do_run(simulation, [:turn_left | tail]),
    do: simulation |> Simulation.turn_left() |> do_run(tail)

  defp do_run(simulation, [:turn_right | tail]),
    do: simulation |> Simulation.turn_right() |> do_run(tail)

  defp do_run(simulation, [:report | tail]) do
    with %{robot: robot} <- simulation,
         %{x: x, y: y, facing: facing} <- robot,
         {:ok, f} <- Cardinal.to_string(facing) do
      IO.puts("The robot is at (#{x}, #{y}) and is facing #{f}")
    end

    do_run(simulation, tail)
  end

  defp do_run(simulation, [_ | tail]), do: simulation |> do_run(tail)
  defp do_run(simulation, []), do: simulation
end
