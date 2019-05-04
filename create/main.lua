return function(workshop)
	local controllers = {
		theme   = require("tevgit:create/controllers/theme.lua"),
		ui      = require("tevgit:create/controllers/ui.lua"),
		camera  = require("tevgit:create/controllers/camera.lua"),
		console = require("tevgit:create/controllers/console.lua"),
		tool    = require("tevgit:create/controllers/tool.lua")
	}

	controllers.ui.createMainInterface(workshop)

	local selectTool = require("tevgit:create/tools/select.lua")
	local moveTool = require("tevgit:create/tools/move.lua")
	local scaleTool = require("tevgit:create/tools/scale.lua")
	local rotateTool = require("tevgit:create/tools/rotate.lua")
end