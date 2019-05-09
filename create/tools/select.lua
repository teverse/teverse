-- Copyright (c) 2019 teverse.com
-- select.lua

local toolName = "Select"
local toolIcon = "local:hand.png"
local toolDesc = "Use this to select and move primitives."
local toolController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")

local toolActivated = function(id)
    --create interface
    --access tool data at toolsController.tools[id].data
    
    local mouseDown = 0
        
    toolsController.tools[id].data.mouseDownEvent = engine.input:mouseLeftPressed(function ( inp )
        if not inp.systemHandled and #selectionController.selection > 0 then
            local hit, didExclude = engine.physics:rayTestScreenAllHits(engine.input.mousePosition,
                                                                        selectionController.selection)
			
			-- Didexclude is false if the user didnt drag starting from one of the selected items.
			if didExclude == false then return end
			
            local currentTime = os.clock()
            mouseDown = currentTime
            
            wait(0.25)
            if mouseDown == currentTime then
                --user held mouse down for 0.25 seconds,
                --initiate drag
                local gridStep = 1
                
                selectionController.selectable = false
                
                hit = hit and hit[1] or nil
				local startPosition = hit and hit.hitPosition or vector3(0,0,0)
				local lastPosition = startPosition
				local startRotation = selectionController.selection[1].rotation
				local offsets = {}

				for i,v in pairs(selectionController.selection) do
					if i > 1 then 
						local relative = startRotation:inverse() * v.rotation;	
						local positionOffset = (relative*selectionController.selection[1].rotation):inverse() * (v.position - selectionController.selection[1].position) 
						offsets[v] = {positionOffset, relative}
					end
				end

				local lastRot = applyRot
				
				
            end
        end
    end)
    
    toolsController.tools[id].data.mouseUpEvent = engine.input:mouseLeftPressed(function ( inp )
        mouseDown = 0
    end)
end

local toolDeactivated = function(id)
    --clean up
    toolsController.tools[id].data.mouseDownEvent:disconnect()
    toolsController.tools[id].data.mouseDownEvent = nil
    toolsController.tools[id].data.mouseUpEvent:disconnect()
    toolsController.tools[id].data.mouseUpEvent = nil
end

return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
