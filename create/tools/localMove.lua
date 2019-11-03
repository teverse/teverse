--[[
    This file remains here for reference. 
    This tool behaves as a move tool that operates on the local axes.

    It was being modified for the scale too.
--]]

return error("bad.")
TOOL_NAME = "Resize"
TOOL_ICON = "fa:s-expand-arrows-alt"
TOOL_DESCRIPTION = "Use this to resize primitives."


local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")
local toolSettings = require("tevgit:create/controllers/toolSettings.lua")
local helpers = require("tevgit:create/helpers.lua")

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
   			doNotSerialise=true,
			opacity = 0,
			renderQueue=1,
			size = vector3(0.1, 0.1, 0.1),
			colour = colour(c==1 and 1 or 0, c==2 and 1 or 0, c==3 and 1 or 0),
			emissiveColour = colour(c==1 and .8 or 0, c==2 and .8 or 0, c==3 and .8 or 0), 
			workshopLocked = true
		})
		
		handle:mouseLeftPressed(function()
			if leftButtonDown then return end -- how
			
			leftButtonDown = handle 
			
			selectionController.selectable = false
			gridGuideline.size = vector3(300, 0.1, 300)
			gridGuideline.rotation = handle.rotation
			gridGuideline.opacity = 0.5
			gridGuideline.position = handle.position


			local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
			if not mouseHit or not mouseHit.object == gridGuideline then
				return print("Error, couldn't cast ray to guideline.")
			end

			local mouseoffsets = {}
			for _,v in pairs(selectionController.selection) do
				mouseoffsets[v] = (mouseHit.hitPosition - v.position)
			end

			local lastHit = mouseHit.hitPosition

			local gridStep = toolSettings.gridStep
			
			repeat 
				if toolsController.currentToolId == toolId then
					--Face camera on one Axis
					 --gridGuideline.position = handle.position
					--gridGuideline.rotation = handle.rotation

					if component == "y" then
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
						local moved = lastHit - target
						lastHit = target

						for _,v in pairs(selectionController.selection) do
							if mouseoffsets[v] then
								local newPos = target - mouseoffsets[v]
								local pos = v.position

								if component == "y" then
									if gridStep > 0 and toolSettings.axis[2][2] then
										pos.y = helpers.roundToMultiple(newPos.y, gridStep)
									else
										pos.y = newPos.y
									end
								else

									if gridStep > 0 and toolSettings.axis[1][2] then
										pos.x = helpers.roundToMultiple(newPos.x, gridStep)
									else
										pos.x = newPos.x
									end


									if gridStep > 0 and toolSettings.axis[3][2] then
										pos.z = helpers.roundToMultiple(newPos.z, gridStep)
									else
										pos.z = newPos.z
									end
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
	
	engine.input:mouseLeftReleased(function()
		leftButtonDown = false
	end)

	updateHandles = function()
		if #selectionController.selection == 0 then
			for _,v in pairs(toolsController.tools[toolId].data.handles) do
				v[1].size = vector3(0,0,0)
				v[1].opacity = 0
			end
		else
			for _,v in pairs(toolsController.tools[toolId].data.handles) do
				local b = selectionController.selection[1]
				v[1].position = b.position + b.rotation* ((v[2] * b.size/2) + (v[2]*1.5)) 
				v[1]:lookAt(b.position)
				v[1].rotation = v[1].rotation * quaternion():setEuler(math.rad(-90),math.rad(90),0)
				v[1].size = vector3(0.35, 0.35, 0.35)
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
end

return toolsController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
	description = TOOL_DESCRIPTION,
	
    hotKey = enums.key.number4,

    activated = onToolActivated,
    deactivated = onToolDeactivated

})
