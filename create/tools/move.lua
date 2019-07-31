--[[
    Copyright 2019 Teverse
    @File move.lua
    @Author(s) Jay
--]]

TOOL_NAME = "Move"
TOOL_ICON = "fa:s-arrows-alt"
TOOL_DESCRIPTION = "Use this to move primitives along an axis."

local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")
local toolSettings = require("tevgit:create/controllers/toolSettings.lua")
local helpers = require("tevgit:create/helpers.lua")
local history = require("tevgit:create/controllers/history.lua")

local mouseUpEvent

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
	
	toolsController.tools[toolId].data.handles = {}
	local components = {"x", "y", "z"}
	local c = 1
	local o = 0
	
	local leftButtonDown = false

	-- For history and adding undo points.
	local originalPositions = {}

	-- Probably can be improved
	-- Creates two 'handles' for each axis.
	-- Should work on all selected items.

	for i = 1,6 do
		local component = components[c]
		local face = vector3(0,0,0)
		face[component] = o == 0 and o-1 or o
		local thisC = c
		
		local handle = engine.construct("block", nil, {
			name = "_CreateMode_",
			castsShadows = false,
			opacity = 0,
			renderQueue=1,
			doNotSerialise=true,
			size = vector3(0.1, 0.1, 0.1),
			colour = colour(c==1 and 1 or 0, c==2 and 1 or 0, c==3 and 1 or 0),
			emissiveColour = colour(c==1 and .8 or 0, c==2 and .8 or 0, c==3 and .8 or 0), 
			workshopLocked = true,
			mesh = "primitive:cone"
		})



		handle:mouseLeftPressed(function()
            print("clicked")
			if leftButtonDown then return end -- how
			print("continued")
			leftButtonDown = handle 
			
			selectionController.selectable = false
			gridGuideline.size = vector3(300, 0.1, 300)
			gridGuideline.rotation = handle.rotation
			gridGuideline.position = handle.position
			if component == "x" then
				gridGuideline.rotation =  gridGuideline.rotation * quaternion():setEuler(math.rad(-45),math.rad(-45),0)
			end

			local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
			if not mouseHit or not mouseHit.object == gridGuideline then
				return print("Error, couldn't cast ray to guideline.")
			end

			local mouseoffsets = {}
            originalPositions = {}
			for _,v in pairs(selectionController.selection) do
				mouseoffsets[v] = (mouseHit.hitPosition - v.position)
				originalPositions[v] = v.position
			end

			local lastHit = mouseHit.hitPosition

			local gridStep = toolSettings.gridStep
			-- IM CURRENTLY THINKING
			-- Add special hook function to history.lua for only accepting values with intervals (needed for move & resize, maybe rotate)
			-- and it gets the difference between two values

			-- OR: Detect when mouse released from marker and then store that value. Add it to history if pos if updated again?
			-- This could use lastHit or something similar?
			repeat 
				if toolsController.currentToolId == toolId then
					--Face camera on one Axis
					gridGuideline.position = handle.position
					if component == "x" then
						local xVector1 = vector3(0, gridGuideline.position.y,gridGuideline.position.z)
						local xVector2 = vector3(0, workspace.camera.position.y, workspace.camera.position.z)

						local lookAt = gridGuideline.rotation:setLookRotation( xVector1 - xVector2 )
						gridGuideline.rotation =  lookAt * quaternion():setEuler(math.rad(45),0,0)
					else
						local pos1 = gridGuideline.position
						pos1[component] = 0

						local pos2 = workspace.camera.position
						pos2[component] = 0

						local lookAt = gridGuideline.rotation:setLookRotation( pos1 - pos2 )
						gridGuideline.rotation =  lookAt * quaternion():setEuler(math.rad(45),0,0)
					end

					local mouseHits = engine.physics:rayTestScreenAllHits( engine.input.mousePosition )
					local mouseHit = nil
					-- We only want the gridGuideline
					for _,hit in pairs(mouseHits) do
						if hit.object == gridGuideline then
							mouseHit = hit
							goto skip_loop
						end
					end
					::skip_loop::

					if mouseHit and mouseHit.object == gridGuideline and lastHit ~= mouseHit.hitPosition then
						local target = mouseHit.hitPosition
						lastHit = target

						for _,v in pairs(selectionController.selection) do
							if mouseoffsets[v] then
								local newPos = target - mouseoffsets[v]
								local pos = v.position
								if gridStep > 0 and toolSettings.axis[thisC][2] then
									pos[component] = helpers.roundToMultiple(newPos[component], gridStep)
								else
									pos[component] = newPos[component]
								end

								v.position = pos
								--engine.tween:begin(v, .05, {position = pos}, "inOutQuad")
							end
						end
					end
				end
				wait()
			until not leftButtonDown or not toolsController.currentToolId == toolId
			
		delay(function() if not leftButtonDown then selectionController.selectable = true end end, 0.3)
			
			if toolsController.currentToolId == toolId then
				gridGuideline.size = vector3(0,0,0)
			end
		end)
		
		table.insert(toolsController.tools[toolId].data.handles, {handle, face})

		if i % 2 == 0 then
			c=c+1
			o = 0
		else
			o = o + 1
		end
	end
	
	mouseUpEvent = engine.input:mouseLeftReleased(function()
		leftButtonDown = false
		if originalPositions then
			for item, pos in pairs(originalPositions) do
				history.addPoint(item, "position", pos)
			end
		end


	end)

	updateHandles = function()
		if selectionController.boundingBox.size == vector3(0,0,0) then
			for _,v in pairs(toolsController.tools[toolId].data.handles) do
				v[1].size = vector3(0,0,0)
				v[1].opacity = 0
			end
		else
			for _,v in pairs(toolsController.tools[toolId].data.handles) do
				v[1].position = selectionController.boundingBox.position + selectionController.boundingBox.rotation* ((v[2] * selectionController.boundingBox.size/2) + (v[2]*1.5)) 
				v[1]:lookAt(selectionController.boundingBox.position)
				v[1].rotation = v[1].rotation * quaternion():setEuler(math.rad(90),0,0)
				v[1].size = vector3(0.2, 0.4, 0.2)
				v[1].opacity = 1
			end
		end
	end

	toolsController.tools[toolId].data.keyDownEvent = engine.input:keyPressed(function ( inp )
		if inp.key == enums.key.t then
			--inputGrid.text = "0"
		end
	end)

	toolsController.tools[toolId].data.boundingEvent = selectionController.boundingBox:changed(updateHandles)
	updateHandles()
end

local function onToolDeactivated(toolId)
	toolsController.tools[toolId].data.gridGuideline:destroy()
	toolsController.tools[toolId].data.gridGuideline = nil
	
	for _,v in pairs(toolsController.tools[toolId].data.handles) do
		v[1]:destroy()
	end
	toolsController.tools[toolId].data.handles = nil
	
	toolsController.tools[toolId].data.boundingEvent:disconnect()
	toolsController.tools[toolId].data.boundingEvent = nil

	if mouseUpEvent then
		mouseUpEvent:disconnect()
		mouseUpEvent = nil
	end
end

return toolsController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
	description = TOOL_DESCRIPTION,
	
    hotKey = enums.key.number3,

    activated = onToolActivated,
    deactivated = onToolDeactivated

})
