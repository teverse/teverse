local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")
local propertyController  = require("tevgit:create/controllers/propertyEditor.lua")
local ui  = require("tevgit:create/controllers/ui.lua")

local remoteTest = toolsController.createButton("topBar", "fa:s-globe", "Test")
local db = false
remoteTest:mouseLeftReleased(function ()
	if db then return end
	db = true
	local backdrop = ui.create("guiFrame", ui.workshop.interface, {
		size 			= guiCoord(1, 0, 1, 0),
		backgroundAlpha = 0,
		zIndex			= 2000
	}, "main")

	engine.tween:begin(backdrop, 0.3, {backgroundAlpha = 0.7}, "inOutQuad")

	local window = ui.create("guiFrame", backdrop, {
		size 			= guiCoord(0, 450, 0, 60),
		position		= guiCoord(0.5, -225, 0.5, -30),
		backgroundAlpha = 0.5,
		borderRadius	= 4
	}, "light")

	engine.tween:begin(window, 0.3, {
		size 			= guiCoord(0, 400, 0, 40),
		position		= guiCoord(0.5, -200, 0.5, -20),
		backgroundAlpha = 0.7,
	}, "inOutQuad")

	local title = ui.create("guiTextBox", window, {
		size 			= guiCoord(1, -10, 1, -10),
		position		= guiCoord(0, 5, 0, 5),
		text 			= "Launching remote server...",
		fontSize		= 20,
		fontFile		= "local:OpenSans-Bold.ttf",
		align			= enums.align.middle,
		backgroundAlpha = 0
	}, "light")

	local loaded = false

	spawnThread(function ()
		wait(5)
		if not loaded and title and title.alive then
			title.text = "This is taking a little longer than usual..."
		end
	end)

    local success = ui.workshop:remoteTestServer(enums.serverLocation.london)
    loaded = true
    if not success then
    	title.text = "Something went wrong?"
    	wait(1)
    end

    db = false
end)