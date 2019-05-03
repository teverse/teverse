print('debug test 1')
local controllers = {
	theme   = require("tevgit:create/controllers/theme.lua"),
	ui      = require("tevgit:create/controllers/ui.lua"),
	camera  = require("tevgit:create/controllers/camera.lua"),
	console = require("tevgit:create/controllers/console.lua"),
	tool    = require("tevgit:create/controllers/tool.lua")
}

print(" creating")
controllers.ui.createMainInterface()

local selectTool = require("tevgit:create/tools/select.lua")
