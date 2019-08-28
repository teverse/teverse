local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")
local propertyController  = require("tevgit:create/controllers/propertyEditor.lua")

local light = toolsController.createButton("createTab", "fa:s-lightbulb", "Light")
light:mouseLeftReleased(function ()
	local l = engine.construct("light", workspace, {
		position = workspace.camera.position - (workspace.camera.rotation * vector3(0,0,5))
	})

	propertyController.generateProperties(l)
end)

local script = toolsController.createButton("createTab", "fa:s-microchip", "Script")
script:mouseLeftReleased(function ()
	require("tevgit:create/controllers/scriptController.lua").newScriptDialogue(workspace)
end)

    -- temp:
    local graphicsSettings = toolsController.createButton("topBar", "fa:s-cogs", "Graphics")
    graphicsSettings:mouseLeftReleased(function ()
        propertyController.generateProperties(engine.graphics)
    end) 
