-- Copyright 2019 teverse.com

local toolsController = {}
local themeController = require("tevgit:create/controllers/theme.lua")

-- container is set in ui.lua when main interface is created
toolsController.container = nil
toolsController.ui = nil
toolsController.workshop = nil

toolsController.currentTool = 0
toolsController.tools = {}

toolsController.setup = function()

end

-- "data" is a table that can be read and written to by activation and deactivation functions
-- these functions should access it via toolsController.tools[id].data
toolsController.add = function(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated, data)
    local toolId = #toolsController.tools + 1
    local button = toolsController.ui.create("guiImage", 
                                             toolsController.container, 
                                             {   
                                                 size = guiCoord(0, 30, 0, 30),
                                                 position = guiCoord(0, 5, 0, 5 + (40 * #toolsController.tools)),
                                                 guiStyle = enums.guiStyle.noBackground,
                                                 texture = toolIcon,
                                                 imageColour = themeController.currentTheme.tools.deselected
                                             },
                                             "main")
    button:mouseLeftReleased(function()
        if toolsController.tools[toolsController.currentTool] then
			toolsController.tools[toolsController.currentTool].gui.imageColour = themeController.currentTheme.tools.deselected
			if toolsController.tools[toolsController.currentTool].deactivate then
				toolsController.tools[toolsController.currentTool].deactivate(toolsController.currentTool)
			end
		end

		if toolsController.currentTool == toolId then
			toolsController.currentTool = 0
		else
			toolsController.currentTool = toolId
			print("debug: activating tool")
			toolsController.tools[toolId].gui.imageColour = themeController.currentTheme.tools.selected
			if toolsController.tools[toolsController.currentTool].activate then
				toolsController.tools[toolsController.currentTool].activate(toolId)
			end
		end
    end)
print("debug: inser tool")
    table.insert(toolsController.tools, {id = toolId, 
                                  gui = button, 
                                  data = data and data or {},
                                  activate = toolActivated, 
                                  deactivate=toolDeactivated})
    return toolsController.tools[toolId]
end

return toolsController
