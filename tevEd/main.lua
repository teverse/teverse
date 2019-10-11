--local module = {}
local tevEd = require("tevgit:tevEd/tevEd.lua")

tevEd.addTutorial("Introduction", "Getting Started", "tevEd/tutorials/intro.lua")
--[[
tevEd.addTutorial("Introduction", "Introducing Blocks", "tevEd/tutorials/intro.lua")
tevEd.addTutorial("Introduction", "Introducing GUIs", "tevEd/tutorials/intro.lua")

tevEd.addTutorial("3D", "Using Meshes", "tevEd/tutorials/intro.lua")
tevEd.addTutorial("3D", "Physics Forces", "tevEd/tutorials/intro.lua")
tevEd.addTutorial("3D", "Making an Interactive Scene", "tevEd/tutorials/intro.lua")

tevEd.addTutorial("Interfaces", "Fun with Frames", "tevEd/tutorials/intro.lua")
tevEd.addTutorial("Interfaces", "Introducing Images", "tevEd/tutorials/intro.lua")
--]]

local mainContainer = nil
local workshop = nil

local function runTutorial(module)
	mainContainer:destroyAllChildren()
	local tutorial = require("tevgit:"..module)

	local tutorialContainer = engine.construct("guiFrame", mainContainer, {
		size			= guiCoord(1, 0, 1, -20),
		backgroundAlpha = 0.1,
		backgroundColour=colour:black(),
	})

	local header = engine.construct("guiFrame", mainContainer, {
		size			= guiCoord(1, 0, 0, 50),
		backgroundAlpha = 0.1,
		backgroundColour=colour:white(),
	})

	local title = engine.construct("guiTextBox", header, {
		size 			= guiCoord(1,-20,1,0),
		position 		= guiCoord(0,10,0,0),
		backgroundAlpha = 0,
		align 			= enums.align.middleLeft,
		fontFile	  	= "OpenSans-SemiBold.ttf",
		fontSize 		= 24,
		text 			= tutorial.name
	})

	engine.construct("guiTextBox", header, {
		size 			= guiCoord(1,-(title.textDimensions.x + 30),1,0),
		position 		= guiCoord(0,(title.textDimensions.x + 20),0,0),
		backgroundAlpha = 0,
		align 			= enums.align.middleLeft,
		fontFile	  	= "OpenSans-Regular.ttf",
		fontSize 		= 18,
		textAlpha 	 	= 0.5,
		text 			= tutorial.description
	})

	local body = engine.construct("guiFrame", tutorialContainer, {
		size			= guiCoord(1, 0, 1, -50),
		backgroundAlpha = 0,
		position 		= guiCoord(0,0,0,50)
	})
	
	local instructions = engine.construct("guiFrame", body, {
		size			= guiCoord(1/4, 0, 1, 0),
		backgroundColour= colour:white(),
	})

	local code = engine.construct("guiFrame", body, {
		size			= guiCoord(1/2, 0, 1, 0),
		position 		= guiCoord(1/4, 0, 0, 0),
		backgroundColour= colour:fromRGB(40,42,54),
	})

	local codeTxt = engine.construct("guiTextBox", code, {
		size 			= guiCoord(1, -20, 1, -14),
		position 		= guiCoord(0, 10, 0, 7),
		align			= enums.align.topLeft,
		fontFile 		= "tevurl:font/FiraCode-Regular.otf",
		fontSize		= 20,
		backgroundAlpha = 0,
		multiline		= true,
		readOnly 		= true,
		wrap 	 		= true,
		text 			= ""
	})

	for _,page in pairs(tutorial.tutorial) do
		instructions:destroyAllChildren()
		if type(page) == "string" then
			local txt = engine.construct("guiTextBox", instructions, {
				size 			= guiCoord(1,-10,1,-10),
				position 		= guiCoord(0,5,0,5),
				backgroundAlpha = 0,
				align 			= enums.align.topLeft,
				wrap = true,
				fontFile	  	= "OpenSans-Regular.ttf",
				fontSize 		= 20,
				text 			= page,
				textColour 		= colour:black(),
				handleEvents 	= false
			})

			local yield = true
			local btn = engine.construct("guiTextBox", instructions, {
				size 			= guiCoord(0, 120, 0, 24),
				position 		= guiCoord(0,5,0,txt.textDimensions.y + 15),
				align 			= enums.align.middle,
				fontFile	  	= "OpenSans-Regular.ttf",
				fontSize 		= 20,
				text 			= "Next",
				backgroundColour= colour(0.4, 0.4, 0.4),
				borderRadius 	= 4
			})

			btn:once("mouseLeftReleased", function ()
				yield = false
			end)

			repeat wait() until not yield

			btn:destroy()
		elseif type(page) == "table" then
			local y = 5
			for _,v in pairs(page) do
				if type(v) == "string" then
					local txt = engine.construct("guiTextBox", instructions, {
						size 			= guiCoord(1,-10,1,-10),
						position 		= guiCoord(0,5,0,y),
						backgroundAlpha = 0,
						align 			= enums.align.topLeft,
						wrap = true,
						fontFile	  	= "OpenSans-Regular.ttf",
						fontSize 		= 20,
						text 			= v,
						textColour 		= colour:black(),
						handleEvents 	= false
					})

					y = y + txt.textDimensions.y + 15

					local yield = true
					local btn = engine.construct("guiTextBox", instructions, {
						size 			= guiCoord(0, 120, 0, 22),
						position 		= guiCoord(0,5,0,y),
						align 			= enums.align.middle,
						fontFile	  	= "OpenSans-Regular.ttf",
						fontSize 		= 20,
						text 			= "Continue",
						backgroundColour= colour(0.4, 0.4, 0.4),
						borderRadius 	= 4
					})

					btn:once("mouseLeftReleased", function ()
						yield = false
					end)

					repeat wait() until not yield

					btn:destroy()
				elseif type(v) == "table" then
					if v.type == "script" then
						codeTxt.text = v.script

						local btn = engine.construct("guiTextBox", instructions, {
							size 			= guiCoord(0, 120, 0, 22),
							position 		= guiCoord(0,5,0,y),
							align 			= enums.align.middle,
							fontFile	  	= "OpenSans-Regular.ttf",
							fontSize 		= 20,
							text 			= v.btnText,
							backgroundColour= colour(0.4, 0.4, 0.4),
							borderRadius 	= 4
						})

						btn:once("mouseLeftReleased", function ()
							v.action(workshop, codeTxt.text)
							btn:destroy()
						end)

					elseif v.type == "helpText" then
						local txt = engine.construct("guiTextBox", instructions, {
							size 			= guiCoord(1,-10,1,-10),
							position 		= guiCoord(0,5,0,y),
							backgroundAlpha = 0,
							align 			= enums.align.topLeft,
							wrap 			= true,
							fontFile	  	= "tevurl:font/OpenSans-Italic.ttf",
							fontSize 		= 20,
							text 			= v.text,
							textColour 		= colour:black(),
							handleEvents 	= false
						})

						y = y + txt.textDimensions.y + 15
					end
				end
			end
		end
	end
end

local function createMainInterface()
	mainContainer:destroyAllChildren()
	local sectionYPos = 0
	for section, tutorials in pairs(tevEd.tutorials) do

		local sectionContainer = engine.construct("guiFrame", mainContainer, {
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
				backgroundAlpha 	= 0.1,
				hoverCursor 		= "fa:s-hand-pointer"
			})

			tutorialContainer:mouseLeftReleased(function ()
				runTutorial(tutorial[2])
			end)

			tutorialContainer:mouseFocused(function ()
				tutorialContainer.backgroundAlpha = 0.2
			end)

			tutorialContainer:mouseUnfocused(function ()
				tutorialContainer.backgroundAlpha = 0.1
			end)

			engine.construct("guiTextBox", tutorialContainer, {
				size 			= guiCoord(0, 30,0,30),
				position 		= guiCoord(0,0,0,0),
				backgroundAlpha = 0.1,
				textAlpha 	 	= 0.5,
				align 			= enums.align.middle,
				fontFile	  	= "OpenSans-SemiBold.ttf",
				fontSize 		= 20,
				backgroundColour= colour:black(),
				text 			= tostring(i),
				handleEvents 	= false,
			})

			engine.construct("guiTextBox", tutorialContainer, {
				size 			= guiCoord(1,-45,0,20),
				position 		= guiCoord(0,40,0,5),
				backgroundAlpha = 0,
				align 			= enums.align.middleLeft,
				fontFile	  	= "OpenSans-Regular.ttf",
				fontSize 		= 20,
				text 			= tutorial[1],
				handleEvents 	= false,
			})

			yPos = yPos + 40
		end

		sectionContainer.size = guiCoord(0, 240, 0, yPos)
		sectionYPos = sectionYPos + yPos + 10
	end
end

return function(c, w)
	mainContainer = c
	workshop = w
	createMainInterface()
end