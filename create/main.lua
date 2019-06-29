-- Copyright (c) 2019 teverse.com
-- main.lua

return function(workshop)
	local controllers = {
		console   = require("tevgit:create/controllers/console.lua"),
		selection = require("tevgit:create/controllers/select.lua"),
		theme     = require("tevgit:create/controllers/theme.lua"),
		ui        = require("tevgit:create/controllers/ui.lua"),
		camera    = require("tevgit:create/controllers/camera.lua"),
		tool      = require("tevgit:create/controllers/tool.lua"),
		property  = require("tevgit:create/controllers/propertyEditor.lua"),
		hotkeys   = require("tevgit:create/controllers/hotkeys.lua")
	}

	controllers.ui.createMainInterface(workshop)
	controllers.console.createConsole(workshop)
	controllers.property.createUI(workshop)

	--loaded here due to dependencies
	controllers.env = require("tevgit:create/controllers/environment.lua")

	controllers.toolSettings = require("tevgit:create/controllers/toolSettings.lua")
	controllers.toolSettings.createUI(workshop)

	local tools = {
		add    = require("tevgit:create/tools/add.lua"),
		select = require("tevgit:create/tools/select.lua"),
		move   = require("tevgit:create/tools/move.lua"),
		scale  = require("tevgit:create/tools/scale.lua"),
		paint  = require("tevgit:create/tools/paint.lua"),
		--rotate = require("tevgit:create/tools/rotate.lua")
	}

	-- create default environment
	if workshop.gameFilePath == "" then
		controllers.env.setDefault()
		controllers.env.createStarterMap() -- Starter map, or the environment, may be overriden by teverse if the user is opening an existing .tev file.
	end
	wait(.3)
	collectgarbage()
	require("tevgit:create/controllers/dock.lua").loadSettings()
	require("tevgit:create/controllers/devtools.lua")
	collectgarbage()
	controllers.ui.setLoading(false)
	--wait(1)
	--scriptEditor   = require("tevgit:create/scriptEditor/main.lua")
end