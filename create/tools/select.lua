--[[
    Copyright 2019 Teverse
    @File select.lua
    @Author(s) Jay, joritochip
--]]

-- TODO: Create a UI that allows the user to input a step size
print("load")
TOOL_NAME = "Select"
TOOL_ICON = "fa:s-hand-paper"
TOOL_DESCRIPTION = "Use this select and move primitives."

local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")
local toolSettings = require("tevgit:create/controllers/toolSettings.lua")
local helpers = require("tevgit:create/helpers.lua")

local function onToolActivated(toolId)
    local mouseDown = 0
    local applyRot = 0
	local gridStep = toolSettings.gridStep

    selectionController.selectable = true

    toolsController.tools[toolId].data.mouseDownEvent = engine.input:mouseLeftPressed(function ( inp )
        if not inp.systemHandled and #selectionController.selection > 0 then
    
    applyRot = 0

            local selectionAtBegin = selectionController.selection

            local hit, didExclude = engine.physics:rayTestScreenAllHits(engine.input.mousePosition,
                                                                        selectionAtBegin)

            local objectSelectedHit = nil
            local objectSelectedHits = engine.physics:rayTestScreenAllHits(engine.input.mousePosition)
            for _,v in pairs(objectSelectedHits) do
                for _,vv in pairs(selectionAtBegin) do
                    if vv == v.object then
                        objectSelectedHit = v
                        goto continue
                    end
                end
            end
			
            ::continue::

			-- Didexclude is false if the user didnt drag starting from one of the selected items.
			if didExclude == false or not objectSelectedHit then return end

			
            local currentTime = os.clock()
            mouseDown = currentTime
            
            wait(0.25)
            if mouseDown == currentTime then
                --user held mouse down for 0.25 seconds,
                --initiate drag
                
                selectionController.selectable = false
                
                hit = hit and hit[1] or nil
				local startPosition = hit and hit.hitPosition or vector3(0,0,0)
                local startOffset = (objectSelectedHit.object.position -objectSelectedHit.hitPosition)
                startOffset.y =0
				local lastPosition = startPosition
				local startRotation = objectSelectedHit.object.rotation
				local offsets = {}

				for i,v in pairs(selectionAtBegin) do
					if v ~= objectSelectedHit.object then 
						local relative = startRotation:inverse() * v.rotation;	
						local positionOffset = (relative*objectSelectedHit.object.rotation):inverse() * (v.position - objectSelectedHit.object.position) 
						offsets[v] = {positionOffset, relative}
					end
				end

				local lastRot = applyRot
				
				while mouseDown == currentTime and toolsController.currentToolId == toolId do
                    local currentHit = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, selectionAtBegin)
                    if #currentHit >= 1 then 
                        currentHit = currentHit[1]

                        -- supposed to get the face of the object the mouse it over, and then position the block to be on that face.
                        local forward = (currentHit.object.rotation * currentHit.hitNormal):normal()-- * quaternion:setEuler(0,math.rad(applyRot),0)
        
         
                        local currentPosition = (currentHit.hitPosition) + startOffset +  (forward * (objectSelectedHit.object.size/2)) --+ (selectedItems[1].size/2)

                        currentPosition = helpers.roundVectorWithToolSettings(currentPosition)

                        if lastPosition ~= currentPosition or lastRot ~= applyRot then
                            lastRot = applyRot
                            lastPosition = currentPosition

                            local targetRot = startRotation * quaternion:setEuler(0,math.rad(applyRot),0)

                            --engine.tween:begin(selectionAtBegin[1], .2, {position = currentPosition,
                            --                                           rotation = targetRot }, "outQuad")

                            objectSelectedHit.object.position = currentPosition
                            objectSelectedHit.object.rotation = targetRot

                            for i,v in pairs(selectionAtBegin) do
                                if v ~= objectSelectedHit.object then 
                                    v.position = (currentPosition) + (offsets[v][2]*targetRot) * offsets[v][1]
                                    v.rotation = offsets[v][2]*targetRot

                                    --engine.tween:begin(v, .2, {position = (currentPosition) + (offsets[v][2]*targetRot) * offsets[v][1],
                                    --                           rotation = offsets[v][2]*targetRot }, "outQuad")
                                end
                            end

                        end
                    end
                    --calculateBoundingBox()
                    wait()
                end
                selectionController.selectable = true

            end
        end
    end)
    
    toolsController.tools[toolId].data.mouseUpEvent = engine.input:mouseLeftReleased(function ( inp )
        mouseDown = 0
    end)
	
	toolsController.tools[toolId].data.keyPressedEvent = engine.input:keyPressed(function(input)
		if input.systemHandled then return end 
		
		if input.key == enums.key.r then
            applyRot = applyRot + 45
			--gridStep = gridStep == 1 and 0 or 1
		end
	end)
end

local function onToolDeactivated(toolId)
    --clean up
    toolsController.tools[toolId].data.mouseDownEvent:disconnect()
    toolsController.tools[toolId].data.mouseDownEvent = nil
    toolsController.tools[toolId].data.mouseUpEvent:disconnect()
    toolsController.tools[toolId].data.mouseUpEvent = nil
	toolsController.tools[toolId].data.keyPressedEvent:disconnect()
	toolsController.tools[toolId].data.keyPressedEvent = nil
end

return toolsController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    hotKey = enums.key.number2,

    activated = onToolActivated,
    deactivated = onToolDeactivated,

    data = {axis={{"x", true},{"y", false},{"z", true}}}

})
