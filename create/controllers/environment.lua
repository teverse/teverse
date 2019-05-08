-- environment.lua
-- Copyright 2019 Teverse

local environmentController = {}

environmentController.createStarterMap = function()
	print("creating starter map")
	engine.construct("light", workspace, {
		name           = "mainLight",
		offsetPosition = vector3(3, 4, 0),
		type           = enums.lightType.directional,
		offsetRotation = quaternion():setEuler(-0.2, 0.2, 0),
		shadows        = true
	})	

	engine.construct("block", workspace, {
		name           = "basePlate",
		colour         = colour(0.6, 0.6, 0.6),
		size           = vector3(100, 1, 100),
		position       = vector3(0, -1, 0),
		workshopLocked = true
	})

	engine.construct("block", workspace, {
		name           = "redBlock",
		colour         = colour(1, 0, 0),
		size           = vector3(1, 1, 1),
		position       = vector3(0, 0, 0)
	})	

	engine.construct("block", workspace, {
		name           = "greenBlock",
		colour         = colour(0, 1, 0),
		size           = vector3(1, 1, 1),
		position       = vector3(1, 0, 0)
	})	

	engine.construct("block", workspace, {
		name           = "blueBlock",
		colour         = colour(0, 0, 1),
		size           = vector3(1, 1, 1),
		position       = vector3(0.5, 1, 0)
	})	
end

environmentController.setDefault = function()
	engine.graphics.clearColour = colour:fromRGB(155, 155, 155)
	engine.graphics.ambientColour = colour:fromRGB(166, 166, 166)
end

return environmentController