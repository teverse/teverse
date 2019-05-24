local consoleCommands = {}

consoleCommands.getCommands = function(consoleController)
	return {
		echo = {
			commands = {"echo", "repeat"}, -- Allows for aliases
			arguments = {"text"},
			description = "Echoes the given text back to you in the console",
			execute = function(args)
				print(args[1])
			end
		},
		exe = {
			commands = {"loadstring", "execute"},
			arguments = {"code"},
			description = "Executes the given code in the environment",
			execute = function(args)
				engine.workshop:loadString(args)
			end
		},
		clear = {
			commands = {"clear"},
			arguments = {},
			description = "Clears all entries from the output",
			execute = function(args)
				consoleController.outputLines = {}
				print("Cleared console successfully!")
			end
		}
	}
end

return consoleCommands