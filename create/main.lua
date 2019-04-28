local controllers = {
	theme   = require("tevcore:create/controllers/theme.lua"),
	ui      = require("tevcore:create/controllers/ui.lua"),
	camera  = require("tevcore:create/controllers/camera.lua"),
	console = require("tevcore:create/controllers/console.lua"),
	tool    = require("tevcore:create/controllers/tool.lua")
}

controllers.ui.createMainInterface()
