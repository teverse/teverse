local helpers = require("tevgit:tevEd/tutorials/helpers.lua")

return {
	name 			= "Introduction",
	description 	= "This tutorial will introduce the very basics of coding in a 3D sandbox with Lua.",
	difficulty 		= 1,

	tutorial		= {
		"This is a string, it is shown as a message to the user.",
		{"This string is shown to the user", "This message is shown on the sampe page when the user hits next."},
		{	
			"Teverse uses Lua, lets test some sample code before getting started...",
			helpers.code("print(\"Hello Teverse!\")", helpers.runAndContinue),
		},
	}
}