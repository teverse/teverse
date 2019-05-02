-- Copyright 2019 teverse.com

local toolsController = {}
local uiController = require("tevgit:create/controllers/ui.lua")

-- container is set in ui.lua when main interface is created
toolsController.container = nil

toolsController.add = function(toolName, toolIcon, toolDesc, ...)
    local button = uiController.create("guiImage", 
                                        toolsController.container, 
                                        {size=guiCoord(0, 40, 0, 40)},
                                        "main")


end

return toolsController
