local helpers = require("tevgit:tevEd/tutorials/helpers.lua")

return {
	name 			= "Introduction",
	description 	= "This tutorial will introduce the very basics of coding in a 3D sandbox with Lua.",
	difficulty 		= 1,

	tutorial		= {
		"Welcome to tutorial.",
		{"This string is shown to the user", "This message is shown on the sampe page when the user hits next."},
		{	
			"Teverse uses Lua, lets test some sample code before getting started...",
			helpers.helpText("Press run to test this code."),
			-- helpers.runAndContinue is a function that processes the user’s 
			-- input when they hit ‘run’. Any function can be used however,
			-- helpers.runAndContinue is a quick way to simply execute the input w/o validation.
			helpers.code("print(\"Hello Teverse!\")", helpers.runAndContinue),
		},
		"Congratulations, check the output on the right to see your creation!"
	}
}