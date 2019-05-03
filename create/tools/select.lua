-- Copyright 2019 Teverse
-- Select tool

local toolName = "Select"
local toolIcon = "fa:s-times"
local toolDesc = "Use this to select and move primitives."

local toolActivated = function(id)
  
end

local toolDeactivated = function(id)
  
end

local toolController = require("tevgit:create/controllers/tool.lua")
return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
