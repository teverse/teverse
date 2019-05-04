-- Copyright 2019 Teverse
-- Select tool

local toolName = "Select"
local toolIcon = "local:hand.png"
local toolDesc = "Use this to select and move primitives."
local toolController = require("tevgit:create/controllers/tool.lua")

local toolActivated = function(id)
    --create interface
    --access tool data at toolsController.tools[id].data
end

local toolDeactivated = function(id)
  
end

return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
