-- Copyright 2019 Teverse
-- This script is required when workshop is loaded,
-- and engine.workshop is passed to the function returned.
-- e.g. require('tevgit:workshop/main.lua')(engine.workshop)

return function( workshop )
	--[[
		Teverse currently downloads tevgit files from the github repo when requested by the client.
		This is quite slow, so there's a delay between EACH require when the user doesn't have a local tevgit.

		To compensate for this, we'll quickly draw up a UI here BEFORE requiring anymore remote files.
		We will load some files first in order to make a reload button for Development users.
	--]]

	-- Load this now, we need it to make the reload button
	local shared = require("tevgit:workshop/controllers/shared.lua")
	shared.workshop = workshop
	shared.developerMode = not shared.workshop.hasLocalTevGit or shared.workshop:hasLocalTevGit()

	local loadingScreen;
	do
		loadingScreen = engine.construct("guiFrame", workshop.interface, {
			size = guiCoord(1, 0, 1, 0),
			backgroundColour = colour:fromRGB(66, 66, 76),
			zIndex = 1000
		})

		engine.construct("guiTextBox", loadingScreen, {
			size = guiCoord(0.5, 0, 0.5, 0),
			position = guiCoord(0.25, 0, 0.25, 0),
			align = enums.align.middle,
			backgroundAlpha = 0,
			text = "Downloading the latest workshop...\nThis takes longer than a moment during beta."
		})

		if shared.developerMode then
			local emergencyReload = engine.construct("guiTextBox", loadingScreen, {
				text = "Emergency Reload",
				size = guiCoord(0, 200, 0, 30),
				position = guiCoord(0.5, -100, 1, -40),
				backgroundColour = colour:fromRGB(44, 47, 51),
				textColour = colour:fromRGB(255, 255, 255),
				borderRadius = 3,
				hoverCursor = "fa:s-hand-pointer",
				align = enums.align.middle,
			})

			emergencyReload:mouseLeftPressed(function()
	        shared.workshop:reloadCreate()
			end)
		end

		local spinner = engine.construct("guiImage", loadingScreen, {
			size = guiCoord(0, 24, 0, 24),
			position = guiCoord(1, -44, 1, -44),
			texture = "fa:s-sync-alt",
			backgroundAlpha = 0
		})

		local tween;
		tween = engine.tween:begin(spinner, 1, {
			rotation = math.rad(-360)
		}, "inOutQuad", function ()
			tween:reset()
			tween:resume()
		end)
	end

	-- Okay now we can load remote files whilst the user is looking at a loading screen.
	shared.controllers.env = require("tevgit:workshop/controllers/environment/main.lua")

    shared.controllers.history = require("tevgit:workshop/controllers/core/history.lua")

    -- Create the Teverse interface
    require("tevgit:workshop/controllers/ui/createInterface.lua")

    -- Setup the 3D world
    shared.controllers.env:setupEnvironment()
    shared.controllers.env:createDefaultMap()
    --shared.controllers.env:createPBRDebugSpheres()

    if loadingScreen then
    	loadingScreen:destroy()
    	loadingScreen = nil
    end

	--print("Workshop Loaded. ", #engine.workspace.children) Lets not spam the console
end
