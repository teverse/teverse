-- Copyright 2019 Teverse
-- Select tool

local toolName = "Add"
local toolIcon = "fa:s-plus"
local toolDesc = "Use this to insert shapes."
local toolController = require("tevgit:create/controllers/tool.lua")

local toolActivated = function(id)
    --create interface
    --access tool data at toolsController.tools[id].data
end

local toolDeactivated = function(id)
  
end

return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
