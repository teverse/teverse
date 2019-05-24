local consoleController = require("tevgit:create/controllers/console.lua")

return  {
    echo = {
        commands = {"echo", "repeat"}, -- Allows for aliases
        arguments = {"textToEcho"},
        description = "Echoes the given text back to you in the console - Used as a test command",
        execute = function(args)
            print(args[1])
        end
    },
	exe = {
		commands = {"loadstring", "execute"},
		arguments = {"code"},
		description = "Executes the given code in the environment",
		execute = fucntion(args)
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