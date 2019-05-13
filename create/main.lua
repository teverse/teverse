-- Copyright (c) 2019 teverse.com
-- main.lua

return function(workshop)
	local controllers = {
		selection = require("tevgit:create/controllers/select.lua"),
		theme     = require("tevgit:create/controllers/theme.lua"),
		ui        = require("tevgit:create/controllers/ui.lua"),
		camera    = require("tevgit:create/controllers/camera.lua"),
		console   = require("tevgit:create/controllers/console.lua"),
		tool      = require("tevgit:create/controllers/tool.lua"),
		env       = require("tevgit:create/controllers/environment.lua")
	}

	controllers.ui.createMainInterface(workshop)

	local tools = {
		add    = require("tevgit:create/tools/add.lua"),
		select = require("tevgit:create/tools/select.lua"),
		move   = require("tevgit:create/tools/move.lua"),
		scale  = require("tevgit:create/tools/scale.lua"),
		rotate = require("tevgit:create/tools/rotate.lua")
	}

	-- create default environment
	controllers.env.setDefault()
	controllers.env.createStarterMap() -- Starter map, or the enviroment, may be overriden by teverse if the user is opening an existing .tev file.
	wait(2)
	controllers.ui.setLoading(false)
end