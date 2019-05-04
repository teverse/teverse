-- Copyright 2019 Teverse
-- Select tool

local toolName = "Move"
local toolIcon = "local:move.png"
local toolDesc = "Use this to move primitives along an axis."
local toolController = require("tevgit:create/controllers/tool.lua")

local toolActivated = function(id)
    --create interface
    --access tool data at toolsController.tools[id].data
end

local toolDeactivated = function(id)
  
end

return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
