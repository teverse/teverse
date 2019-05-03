-- Copyright 2019 teverse.com

local toolsController = {}

-- container is set in ui.lua when main interface is created
toolsController.container = nil
toolsController.ui = nil

toolsController.currentTool = 0
toolsController.tools = {}

-- "data" is a table that can be read and written to by activation and deactivation functions
-- these functions should access it via toolsController.tools[id].data
toolsController.add = function(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated, data)
    local toolId = #toolsController.tools + 1
    local button = toolsController.ui.create("guiImage", 
                                             toolsController.container, 
                                             {   
                                                 size = guiCoord(0, 40, 0, 40),
                                                 position = guiCoord(0, 0, 0, 5 + (30 * #toolsController.tools)),
                                                 guiStyle = enums.guiStyle.noBackground,
                                                 texture = toolIcon
                                             },
                                             "main")

    toolsController.tools:insert({id = toolId, 
                                  gui = button, 
                                  data = data and data or {},
                                  activate = toolActivated, 
                                  deactivate=toolDeactivated})

end

return toolsController
