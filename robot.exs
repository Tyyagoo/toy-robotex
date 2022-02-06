File.stream!("commands.txt")
|> Enum.map(&String.trim/1)
|> ToyRobot.Command.Parser.parse()
|> ToyRobot.Command.Runner.run()
