--[[
    Copyright 2019 Teverse
    @File scale.lua
    @Author(s) Jay
--]]

TOOL_NAME = "Scale"
TOOL_ICON = "local:scale.png"
TOOL_DESCRIPTION = "Use this to resize primitives."

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
