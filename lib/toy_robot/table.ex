defmodule ToyRobot.Table do
  alias __MODULE__

  @enforce_keys [:max_x, :max_y]
  defstruct [:max_x, :max_y]

  @type t :: %__MODULE__{max_x: integer(), max_y: integer()}

  @spec new(x :: integer(), y :: integer()) :: t()
  def new(x, y), do: %Table{max_x: x, max_y: y}

  @doc """
  Determines if a position would be within the table's boundaries.
  
  ## Examples
  
    iex> alias ToyRobot.Table
    ToyRobot.Table
    iex> table = %Table{max_x: 4, max_y: 4}
    %Table{max_x: 4, max_y: 4}
    iex> table |> Table.valid_position?(4, 4)
    true
    iex> table |> Table.valid_position?(0, 0)
    true
    iex> table |> Table.valid_position?(6, 0)
    false
  """
  @spec valid_position?(table :: t(), x :: integer(), y :: integer()) :: boolean()
  def valid_position?(%Table{max_x: max_x, max_y: max_y}, x, y) do
    x >= 0 and x <= max_x and y >= 0 and y <= max_y
  end
end
