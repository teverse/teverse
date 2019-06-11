-- Copyright (c) 2019 teverse.com
-- environment.lua

local environmentController = {}

local firstRun = true

local toolsController = require("tevgit:create/controllers/tool.lua")
local physicsButton = toolsController.createButton("testingTab", "fa:s-play", "Resume")
physicsButton:mouseLeftReleased(function ()
    if engine.physics.running then
    	engine.physics:pause()
    else
    	engine.physics:resume()
    end
end)
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
end)

environmentController.createStarterMap = function()
	print("creating starter map")
	local mainLight = engine.construct("light", workspace, {
		name           = "mainLight",
		position       = vector3(3, 4, 0),
		type           = enums.lightType.directional,
		rotation       = quaternion():setEuler(-0.2, 0.2, 0),
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

	local block = engine.construct("block", workspace, {
		name           = "blueBlock",
		colour         = colour(0, 0, 1),
		size           = vector3(1, 1, 1),
		position       = vector3(0.5, 1, 0)
	})	
	
	engine.construct("block", workspace, {
		name           = "duck",
		colour         = colour(1, 1, 1),
		size           = vector3(1.68787964, 1.67249405, 1.117558464),
		position       = vector3(0.5, 2.21, 0),
		mesh           = "tevurl:3d/Duck.glb"
	})	

	local corset = engine.construct("block", workspace, {
		name           = "corset",
		colour         = colour(1, 1, 1),
		size           = vector3(1.98645, 2.9499, 1.98645),
		position       = vector3(-3, 0.94, 4),
		rotation       = quaternion:setEuler(0, math.rad(-45), 0),
		mesh           = "tevurl:3d/Corset.glb"
	})

	--[[local light = engine.construct("light", workspace, {
		name               = "corsetSpotLight",
		diffuseColour      = colour(20, 15, 15), --Lights accept colours higher than the standard 1,1,1 scheme
		specularColour     = colour(20, 15, 15),
		position           = vector3(2, 3.94, 7.5),
		falloff            = 2,
		lumThreshold       = 0.15,
		shadows            = true,
		shadowFarDistance  = 100,
		shadowFarClip      = 30,
		type               = enums.lightType.spot
	})

	light:lookAt(corset.position)

	]]

	

	if firstRun then
		firstRun = false
		--hack: pregenerate properties
		require("tevgit:create/controllers/propertyEditor.lua").generateProperties(block)
		require("tevgit:create/controllers/propertyEditor.lua").generateProperties(mainLight)
	end

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