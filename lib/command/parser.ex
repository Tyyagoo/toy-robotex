defmodule ToyRobot.Command.Parser do
  import ToyRobot.Mixins, only: [parse_integer: 1]
  alias ToyRobot.Cardinal

  @doc """
  Parses commands from a commands list, in preparation for running them.
  
  ## Examples
  
    iex> alias ToyRobot.Command.Parser
    ToyRobot.Command.Parser
    iex> ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "REPORT"] |> Parser.parse()
    [
      {:place, %{x: 1, y: 2, facing: :north}},
      :move,
      :turn_left,
      :turn_right,
      :report,
    ]
  """
  @spec parse(list(Strint.t())) :: list(atom() | tuple())
  def parse(commands) do
    commands
    |> Enum.map(&parse_command/1)
    |> Enum.filter(fn cmd -> cmd != nil end)
  end

  @spec parse_command(command :: String.t()) :: atom() | tuple()
  defp parse_command("MOVE"), do: :move
  defp parse_command("LEFT"), do: :turn_left
  defp parse_command("RIGHT"), do: :turn_right
  defp parse_command("REPORT"), do: :report

  defp parse_command("PLACE " <> args) do
    args
    |> String.split(",", trim: true)
    |> (
      fn _ -> nil end

      fn [xs, ys, fs] ->
        with {:ok, x} <- parse_integer(xs),
             {:ok, y} <- parse_integer(ys),
             {:ok, facing} <- Cardinal.from_string(fs) do
          {:place, %{x: x, y: y, facing: facing}}
        else
          _ -> nil
        end
      end
    ).()
  end

  defp parse_command(_), do: nil
end
