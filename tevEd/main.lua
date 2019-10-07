--local module = {}
local tevEd = require("tevgit:tevEd/tevEd.lua")

tevEd.addTutorial("Introduction", "Getting Started", "tevgit:tevEd/tutorials/intro.lua")
tevEd.addTutorial("Introduction", "Introducing Blocks", "tevgit:tevEd/tutorials/intro.lua")
tevEd.addTutorial("Introduction", "Introducing GUIs", "tevgit:tevEd/tutorials/intro.lua")

tevEd.addTutorial("3D", "Using Meshes", "tevgit:tevEd/tutorials/intro.lua")
tevEd.addTutorial("3D", "Physics Forces", "tevgit:tevEd/tutorials/intro.lua")
tevEd.addTutorial("3D", "Making an Interactive Scene", "tevgit:tevEd/tutorials/intro.lua")

tevEd.addTutorial("Interfaces", "Fun with Frames", "tevgit:tevEd/tutorials/intro.lua")
tevEd.addTutorial("Interfaces", "Introducing Images", "tevgit:tevEd/tutorials/intro.lua")

return function(container, workshop)
	local sectionYPos = 0
	for section, tutorials in pairs(tevEd.tutorials) do

		local sectionContainer = engine.construct("guiFrame", container, {
			position		= guiCoord(0, 0, 0, sectionYPos),
			backgroundAlpha = 0.1,
			borderRadius 	= 4
		})

		engine.construct("guiTextBox", sectionContainer, {
			size 			= guiCoord(1,-20,0,24),
			position 		= guiCoord(0,10,0,10),
			backgroundAlpha = 0,
			align 			= enums.align.middleLeft,
			fontFile	  	= "OpenSans-SemiBold.ttf",
			fontSize 		= 24,
			text 			= section
		})

		local yPos = 44

		for i,tutorial in pairs(tutorials) do
			local tutorialContainer = engine.construct("guiFrame", sectionContainer, {
				size 				= guiCoord(1, -20, 0, 30),
				position 			= guiCoord(0, 10, 0, yPos),
				backgroundColour  	= colour:black(),
				backgroundAlpha 	= 0.1
			})

			engine.construct("guiTextBox", tutorialContainer, {
				size 			= guiCoord(0, 30,0,30),
				position 		= guiCoord(0,0,0,0),
				backgroundAlpha = 0.1,
				textAlpha 	 	= 0.5,
				align 			= enums.align.middle,
				fontFile	  	= "OpenSans-SemiBold.ttf",
				fontSize 		= 20,
				backgroundColour= colour:black(),
				text 			= tostring(i)
			})

			engine.construct("guiTextBox", tutorialContainer, {
				size 			= guiCoord(1,-45,0,20),
				position 		= guiCoord(0,40,0,5),
				backgroundAlpha = 0,
				align 			= enums.align.middleLeft,
				fontFile	  	= "OpenSans-Regular.ttf",
				fontSize 		= 20,
				text 			= tutorial[1]
			})

			yPos = yPos + 40
		end

		sectionContainer.size = guiCoord(0, 240, 0, yPos)
		sectionYPos = sectionYPos + yPos + 10
	end

end