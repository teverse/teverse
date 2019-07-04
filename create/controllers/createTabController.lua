local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")

local light = toolsController.createButton("createTab", "fa:s-lightbulb", "Light")
light:mouseLeftReleased(function ()
	local l = engine.construct("light", workspace, {
		position = workspace.camera.position + (workspace.camera.rotation * vector3(0,0,6))
	})

	selectionController.setSelection({l})
	propertyController.generateProperties(l)
end)
