defmodule ToyRobot.Cardinal do
  @typedoc """
    Type that represents possible cardinal directions.
  """
  @type t :: :north | :east | :south | :west

  @doc """
  Returns an ok tuple with the atom representation of the direction if it's a valid direction.
  Otherwise returns an error tuple.
  
  ## Examples
    iex> alias ToyRobot.Cardinal
    ToyRobot.Cardinal
    iex> Cardinal.from_string("NORTH")
    {:ok, :north}
    iex> Cardinal.from_string("North")
    {:error, "Invalid direction"}
  """
  @spec from_string(direction :: String.t()) :: {:ok, t()} | {:error, reason :: String.t()}
  def from_string("NORTH"), do: {:ok, :north}
  def from_string("EAST"), do: {:ok, :east}
  def from_string("SOUTH"), do: {:ok, :south}
  def from_string("WEST"), do: {:ok, :west}
  def from_string(_), do: {:error, "Invalid direction"}

  @doc """
  Returns an ok tuple with the String representation of the direction if it's a valid direction.
  Otherwise returns an error tuple.
  
  ## Examples
    iex> alias ToyRobot.Cardinal
    ToyRobot.Cardinal
    iex> Cardinal.to_string(:north)
    {:ok, "NORTH"}
    iex> Cardinal.from_string(:wesp)
    {:error, "Invalid direction"}
  """
  @spec to_string(direction :: t()) :: {:ok, String.t()} | {:error, reason :: String.t()}
  def to_string(:north), do: {:ok, "NORTH"}
  def to_string(:east), do: {:ok, "EAST"}
  def to_string(:south), do: {:ok, "SOUTH"}
  def to_string(:west), do: {:ok, "WEST"}
  def to_string(_), do: {:error, "Invalid direction"}

  @doc """
  Returns an ok tuple with the neighbour of `direction` in the desired sense.
  If some param is invalid, return an error tuple.
  
  ## Examples
    iex> alias ToyRobot.Cardinal
    ToyRobot.Cardinal
    iex> Cardinal.turn(:north, :clockwise)
    {:ok, :east}
  """
  @spec turn(direction :: t(), sense :: :clockwise | :anticlockwise) ::
          {:ok, t()} | {:error, reason :: String.t()}
  def turn(direction, sense) do
    case sense do
      :clockwise -> turn_clockwise(direction)
      :anticlockwise -> turn_anticlockwise(direction)
      _ -> {:error, "Invalid sense"}
    end
  end

  defp turn_clockwise(:north), do: {:ok, :east}
  defp turn_clockwise(:east), do: {:ok, :south}
  defp turn_clockwise(:south), do: {:ok, :west}
  defp turn_clockwise(:west), do: {:ok, :north}
  defp turn_clockwise(_), do: {:error, "Invalid direction"}

  defp turn_anticlockwise(:north), do: {:ok, :west}
  defp turn_anticlockwise(:west), do: {:ok, :south}
  defp turn_anticlockwise(:south), do: {:ok, :east}
  defp turn_anticlockwise(:east), do: {:ok, :north}
  defp turn_anticlockwise(_), do: {:error, "Invalid direction"}
end
