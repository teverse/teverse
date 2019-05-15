-- Copyright (c) 2019 teverse.com
-- environment.lua

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

	--[[
	-- Create a script source.
	-- Noting that this API was not supposed to be used by Developers.
	-- It is most likely only going to be used internally by our engine.

	-- The idea is that a developer can update this script source and multiple "containers" can use one source.
	local scriptSource = engine.construct("scriptSource", engine.assets.lua.shared, {
		name = "main",
		source = "print('test')"
	})

	-- Create a script container, this container is responsible for executing code referenced from a script source.
	-- Each container is treat as its own script and gets its own sandbox.
	local scriptRunner = engine.construct("scriptContainer", engine.workspace, {name = "mainRunner"})
	scriptRunner:attach(scriptSource) -- autoruns if autorun is true (defaults to true)
	]]
end

environmentController.setDefault = function()
	engine.graphics.clearColour = colour:fromRGB(155, 155, 155)
	engine.graphics.ambientColour = colour:fromRGB(166, 166, 166)
end

return environmentController