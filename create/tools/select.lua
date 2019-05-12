--[[
    Copyright 2019 Teverse
    @File select.lua
    @Author(s) Jay
--]]

-- TODO: Create a UI that allows the user to input a step size

TOOL_NAME = "Select"
TOOL_ICON = "fa:s-hand-paper"
TOOL_DESCRIPTION = "Use this select and move primitives."

local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")

local function onToolActivated(toolId)
    local mouseDown = 0
        
    toolsController.tools[toolId].data.mouseDownEvent = engine.input:mouseLeftPressed(function ( inp )
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
    
    toolsController.tools[toolId].data.mouseUpEvent = engine.input:mouseLeftPressed(function ( inp )
        mouseDown = 0
    end)
end

local function onToolDeactviated(toolId)
    --clean up
    toolsController.tools[toolId].data.mouseDownEvent:disconnect()
    toolsController.tools[toolId].data.mouseDownEvent = nil
    toolsController.tools[toolId].data.mouseUpEvent:disconnect()
    toolsController.tools[toolId].data.mouseUpEvent = nil
end

return toolsController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    activated = onToolActivated,
    deactivated = onToolDeactviated

})
