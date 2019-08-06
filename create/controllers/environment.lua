-- Copyright (c) 2019 teverse.com
-- environment.lua

local environmentController = {}

local firstRun = true

local toolsController = require("tevgit:create/controllers/tool.lua")
--[[
local physicsButton = toolsController.createButton("testingTab", "fa:s-pause", "Pause")
physicsButton:mouseLeftReleased(function ()
    if engine.physics.running then
    	engine.physics:pause()
    else
    	engine.physics:resume()
    end
end)
]]



--[[
engine.physics:changed(function (p,v)
	if p == "running" then
		if v then
			physicsButton.image.texture = "fa:s-pause"
			physicsButton.text.text = "Pause"
		else
			physicsButton.image.texture = "fa:s-play"
			physicsButton.text.text = "Resume"
		end
	end
end)]]

environmentController.createStarterMap = function()
	print("creating starter map")
	local mainLight = engine.construct("light", workspace, {
		name           = "mainLight",
		position       = vector3(3, 4, 0),
		type           = enums.lightType.directional,
		rotation       = quaternion():setEuler(-0.2, 0.2, 0),
		shadows        = true
	})	

	local basePlate = engine.construct("block", workspace, {
		name           = "basePlate",
		colour         = colour(0.6, 0.6, 0.6),
		size           = vector3(100, 1, 100),
		position       = vector3(0, -1, 0),
		workshopLocked = true
	})

	basePlate:on("collisionStarted", function (otherBlock, hitPos)
		print("collision", hitPos)
		local marker = engine.construct("block", workspace, {
			physics = false,
			doNotSerialise = true,
			size = vector3(0.1,0.1,0.1),
			colour = colour:random(),
			position = hitPos
		})
		wait(.5)
		marker:destroy()
	end)

	basePlate:on("collisionEnded", function (otherBlock)
		print("Ended", otherBlock)
	end)

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
		position       = vector3(1, 0, 0),
		mesh		   = "primitive:wedge",
		rotation       = quaternion:setEuler(0, math.rad(90), 0)
	})	

	local block = engine.construct("block", workspace, {
		name           = "blueBlock",
		colour         = colour(0, 0, 1),
		size           = vector3(1, 1, 1),
		position       = vector3(0.5, 1, 0),
		mesh  		   = "primitive:sphere"
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
	scriptRunner.source = scriptSource -- autoruns if autorun is true (defaults to true)
	]]
end

environmentController.setDefault = function()
	engine.graphics.clearColour = colour:fromRGB(155, 155, 155)
	engine.graphics.ambientColour = colour:fromRGB(166, 166, 166)
end

return environmentController