defmodule ToyRobot.CLI do
  def main([file_name]) do
    try do
      execute!(file_name)
    rescue
      _ -> IO.puts("The file #{file_name} does not exist")
    end
  end

  def main(_) do
    IO.puts("Usage: escript toy_robot {path}")
  end

  defp execute!(file_name) do
    File.stream!(file_name)
    |> Enum.map(&String.trim/1)
    |> ToyRobot.Command.Parser.parse()
    |> ToyRobot.Command.Runner.run()
  end
end
