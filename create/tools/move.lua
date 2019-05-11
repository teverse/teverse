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

	-- This is used to raycast the user's mouse position to an axis
	local gridGuideline = engine.construct("block", workspace, {
		size = vector3(0,0,0),
		colour = colour(1,1,1),
		opacity = 0,
		workshopLocked = true,
		castsShadows = false
	})
	
	toolsController.tools[toolId].data.gridGuideline = gridGuideline
	
	-- TODO: Refactor code from old create mode...
	--       Everything is essentially the same, apart from UI needs to use the ui controller
	--       And also: engine.construct should be used throughout.
end

local function onToolDeactviated(toolId)
	toolsController.tools[toolId].data.gridGuideline:destroy()
	toolsController.tools[toolId].data.gridGuideline = nil
end

return toolController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    activated = onToolActivated,
    deactivated = onToolDeactviated

})
