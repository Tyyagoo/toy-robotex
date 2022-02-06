defmodule ToyRobot.Mixins do
  @spec parse_integer(str :: String.t()) :: {:error, :not_an_integer} | {:ok, integer()}
  def parse_integer(str) do
    try do
      {:ok, str |> String.to_integer()}
    rescue
      _ in ArgumentError -> {:error, :not_an_integer}
    end
  end
end
