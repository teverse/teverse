--[[
    Copyright 2019 Teverse
    @File rotate.lua
    @Author(s) Jay
--]]

TOOL_NAME = "Rotate"
TOOL_ICON = "fa:s-sync-alt"
TOOL_DESCRIPTION = "Use this to rotate objects"

local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")
local toolSettings = require("tevgit:create/controllers/toolSettings.lua")

local helpers = require("tevgit:create/helpers.lua")
local history = require("tevgit:create/controllers/history.lua")

local arrows = {
	{},
	{},
	{}
}

-- Each axis gets four arrows...
-- This table maps each arrow index to an vertice index
local arrowsVerticesMap = {
	{2, 4, 3, 1}, --x 
	{2, 1, 5, 6}, --y
	{5, 7, 3, 1}  --z
}

local function positionArrows()
	if selectionController.boundingBox.size == vector3(0,0,0) then
		for _,v in pairs(arrows) do
			for i,arrow in pairs(v) do
				arrow.physics = false
				arrow.opacity = 0
			end
		end
	else
		local vertices = helpers.calculateVertices(selectionController.boundingBox)

		for a,v in pairs(arrows) do
			for i,arrow in pairs(v) do
				arrow.physics = true
				arrow.opacity = 1
				arrow.position = vertices[arrowsVerticesMap[a][i]]
				if a == 1 then
					arrow.rotation = quaternion:setEuler(math.rad((i-1)*-90), 0, math.rad(90))
				elseif a == 2 then
					arrow.rotation = quaternion:setEuler(0, math.rad((i-1)*-90), 0)
				else
					arrow.rotation = quaternion:setEuler(math.rad((i-1)*-90), math.rad(90), math.rad(90))
				end
			end
		end
	end
end

local function onToolActivated(toolId)
	for axis = 1, 3 do
		for arrow = 1, 4 do
			local newArrow = engine.construct("block", engine.workspace, {
				name = "_CreateMode_",
				castsShadows = false,
				opacity = 0,
				renderQueue=1,
				doNotSerialise=true,
				size = vector3(.4, 0.1, .4),
				colour = colour(axis == 1 and 1 or 0, axis == 2 and 1 or 0, axis == 3 and 1 or 0),
				emissiveColour = colour(axis == 1 and 0.8 or 0, axis == 2 and 0.8 or 0, axis == 3 and 0.8 or 0),
				workshopLocked = true,
				mesh = "tevurl:3d/arrowCurved.glb"
			})

			table.insert(arrows[axis], newArrow)
		end
	end

	positionArrows()
end

local function onToolDeactivated(toolId)
	for _,v in pairs(arrows) do
		for _,arrow in pairs(v) do
			print(arrow)
			arrow:destroy()
		end
	end

	arrows = {
		{},
		{},
		{}
	}
end

return toolsController:register({
    name = TOOL_NAME,
    icon = TOOL_ICON,
	description = TOOL_DESCRIPTION,
	
    hotKey = enums.key.number5,

    activated = onToolActivated,
    deactivated = onToolDeactivated
})
