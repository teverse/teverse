--[[
    Copyright 2019 Teverse
    @File move.lua
    @Author(s) Jay
--]]

TOOL_NAME = "Move"
TOOL_ICON = "fa:s-arrows-alt"
TOOL_DESCRIPTION = "Use this to move primitives along an axis."

local toolController = require("tevgit:create/controllers/tool.lua")

local function onToolActivated(toolId)
    
end

local function onToolDeactviated(toolId)
  
end

return toolController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    activated = onToolActivated,
    deactivated = onToolDeactviated

})
