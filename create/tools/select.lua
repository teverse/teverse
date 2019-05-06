-- Copyright 2019 Teverse
-- Select tool

local toolName = "Select"
local toolIcon = "local:hand.png"
local toolDesc = "Use this to select and move primitives."
local toolController = require("tevgit:create/controllers/tool.lua")

local toolActivated = function(id)
    --create interface
    --access tool data at toolsController.tools[id].data
    
    tools[id].data.mouseDownEvent = engine.input:mouseLeftPressed(function ( inp )
    
    end)
    
    tools[id].data.mouseUpEvent = engine.input:mouseLeftPressed(function ( inp )
    
    end)
end

local toolDeactivated = function(id)
    --clean up
    tools[id].data.mouseDownEvent:disconnect()
    tools[id].data.mouseDownEvent = nil
end

return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
