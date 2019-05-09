-- Copyright (c) 2019 teverse.com
-- move.lua

local toolName = "Move"
local toolIcon = "fa:arrows-alt"
local toolDesc = "Use this to move primitives along an axis."
local toolController = require("tevgit:create/controllers/tool.lua")

local toolActivated = function(id)
    --create interface
    --access tool data at toolsController.tools[id].data
end

local toolDeactivated = function(id)
  
end

return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
