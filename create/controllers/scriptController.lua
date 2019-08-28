local controller = {}

local ui = require("tevgit:create/controllers/ui.lua")
local selectionController = require("tevgit:create/controllers/select.lua")

-- displays a dialogue to user when they want to make a new container, asks them if they want to use an existing source or not.
controller.newScriptDialogue = function(parent)
	if not parent or not parent.className then return end
	local backdrop = ui.create("guiFrame", ui.workshop.interface, {
		size 			= guiCoord(1, 0, 1, 0),
		backgroundAlpha = 0,
		zIndex			= 2000
	}, "main")

	engine.tween:begin(backdrop, 0.3, {backgroundAlpha = 0.7}, "inOutQuad")

	local window = ui.create("guiFrame", backdrop, {
		size 			= guiCoord(0, 450, 0, 220),
		position		= guiCoord(0.5, -225, 0.5, -110),
		backgroundAlpha = 0.5,
		borderRadius	= 4
	}, "light")

	engine.tween:begin(window, 0.3, {
		size 			= guiCoord(0, 400, 0, 174),
		position		= guiCoord(0.5, -200, 0.5, -87),
		backgroundAlpha = 0.7,
	}, "inOutQuad")

	local title = ui.create("guiTextBox", window, {
		size 			= guiCoord(1, -10, 0, 40),
		position		= guiCoord(0, 5, 0, 10),
		text 			= "Choose a source for your new scriptContainer\nunder " .. (parent and parent.name or "?"),
		fontSize		= 20,
		fontFile		= "OpenSans-Bold.ttf",
		align			= enums.align.middle,
		backgroundAlpha = 0
	}, "light")

	local existingSource = engine.construct("guiFrame", window, {
		size 			= guiCoord(1/3, -4, 1, -56),
		position		= guiCoord(0, 2, 0, 46),
		backgroundAlpha = 0
	})

	ui.create("guiImage", existingSource, {
		size 			= guiCoord(0, 50, 0, 50),
		position		= guiCoord(0.5, -25, 0.5, -25),
		backgroundAlpha = 0,
		texture 		= "fa:s-search",
		handleEvents	= false
	}, "light")

	ui.create("guiTextBox", existingSource, {
		size 			= guiCoord(1, -10, 0, 32),
		position		= guiCoord(0, 5, 0.5, 25),
		backgroundAlpha = 0,
		fontSize 		= 16,
		text     		= "Existing\nSource {TODO!!!}",
		align			= enums.align.topMiddle,
		handleEvents	= false
	}, "light")

	local newServer = engine.construct("guiFrame", window, {
		size 			= guiCoord(1/3, -4, 1, -56),
		position		= guiCoord(1/3, 2, 0, 46),
		backgroundAlpha = 0
	})

	ui.create("guiImage", newServer, {
		size 			= guiCoord(0, 50, 0, 50),
		position		= guiCoord(0.5, -25, 0.5, -25),
		backgroundAlpha = 0,
		texture 		= "fa:s-server",
		handleEvents	= false
	}, "light")

	ui.create("guiTextBox", newServer, {
		size 			= guiCoord(1, -10, 0, 32),
		position		= guiCoord(0, 5, 0.5, 25),
		backgroundAlpha = 0,
		fontSize 		= 16,
		text     		= "New Server\nSource",
		align			= enums.align.topMiddle,
		handleEvents	= false
	}, "light")

	local newClient = engine.construct("guiFrame", window, {
		size 			= guiCoord(1/3, -4, 1, -56),
		position		= guiCoord(2/3, 2, 0, 46),
		backgroundAlpha = 0
	})

	ui.create("guiImage", newClient, {
		size 			= guiCoord(0, 50, 0, 50),
		position		= guiCoord(0.5, -25, 0.5, -25),
		backgroundAlpha = 0,
		texture 		= "fa:s-laptop-code",
		handleEvents	= false
	}, "light")

	ui.create("guiTextBox", newClient, {
		size 			= guiCoord(1, -10, 0, 32),
		position		= guiCoord(0, 5, 0.5, 25),
		backgroundAlpha = 0,
		fontSize 		= 16,
		text     		= "New Client\nSource",
		align			= enums.align.topMiddle,
		handleEvents	= false
	}, "light")

	local keyListener = engine.input:keyPressed(function (inputObj)
		if inputObj.key == enums.key.escape then
			backdrop:destroy()
		end
	end)

	backdrop:once("mouseLeftPressed", function ()
		backdrop:destroy()
	end)

	backdrop:once("destroying", function ()
		keyListener:disconnect()
	end)

	newClient:once("mouseLeftPressed", function ()
		local name = "newClientScript"
		local newSource = engine.construct("scriptSource", engine.assets.lua.client, {name = name.."Source"})
		local newScript = engine.construct("scriptContainer", parent, {name = name.."Container"})
		newScript.scriptType = enums.scriptType.client
		newScript.source = newSource
		selectionController.setSelection({newScript})
		wait(.4)
		backdrop:destroy()
	end)

	newServer:once("mouseLeftPressed", function ()
		local name = "newServerScript"
		local newSource = engine.construct("scriptSource", engine.assets.lua.server, {name = name.."Source"})
		local newScript = engine.construct("scriptContainer", parent, {name = name.."Container"})
		newScript.scriptType = enums.scriptType.server
		newScript.source = newSource
		selectionController.setSelection({newScript})
		wait(.4)
		backdrop:destroy()
	end)
end

controller.editScript = function (obj)
	-- Code here...
	if type(obj) == "scriptSource" then
		obj:editExternal()
	elseif obj.source then
		print(container)
		obj.source:editExternal()
	end
end

return controller