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

-- TODo: move this to a helper module
local roundToMultiple = function(number, multiple)
        if multiple == 0 then 
            return number 
        end

        return ((number % multiple) > multiple/2) and number + multiple - number%multiple or number - number%multiple
    end

local function onToolActivated(toolId)
    local mouseDown = 0
    local applyRot = 0

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
				
				while mouseDown == currentTime and toolsController.currentToolId == toolId do
                    local currentHit = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, selectionController.selection)
                    if #currentHit >= 1 then 
                        currentHit = currentHit[1]

                        local forward = (currentHit.object.rotation * currentHit.hitNormal):normal()-- * quaternion:setEuler(0,math.rad(applyRot),0)
        
                        local currentPosition = currentHit.hitPosition + (forward * (selectionController.selection[1].size/2)) --+ (selectedItems[1].size/2)

                        if gridStep > 0 then
                            for i, v in pairs(toolsController.tools[toolId].data.axis) do
                                if v[2] then
                                    currentPosition[v[1]] = roundToMultiple(currentPosition[v[1]], gridStep)
                                end
                            end
                        end

                        if lastPosition ~= currentPosition or lastRot ~= applyRot then
                            lastRot = applyRot
                            lastPosition = currentPosition

                            local targetRot = startRotation * quaternion:setEuler(0,math.rad(applyRot),0)

                            engine.tween:begin(selectionController.selection[1], .2, {position = currentPosition,
                                                                       rotation = targetRot }, "outQuad")

                            --selectedItems[1].position = currentPosition 
                            --selectedItems[1].rotation = startRotation * quaternion:setEuler(0,math.rad(applyRot),0)
                            --print(selectedItems[1].name)

                            for i,v in pairs(selectionController.selection) do
                                if i > 1 then 
                                    --v.position = (currentPosition) + (offsets[v][2]*selectedItems[1].rotation) * offsets[v][1]
                                    --v.rotation = offsets[v][2]*selectedItems[1].rotation 

                                    engine.tween:begin(v, .2, {position = (currentPosition) + (offsets[v][2]*targetRot) * offsets[v][1],
                                                               rotation = offsets[v][2]*targetRot }, "outQuad")
                                end
                            end

                        end
                    end
                    --calculateBoundingBox()
                    wait()
                end


            end
        end
    end)
    
    toolsController.tools[toolId].data.mouseUpEvent = engine.input:mouseLeftReleased(function ( inp )
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
    deactivated = onToolDeactviated,

    data = {axis={{"x", true},{"y", false},{"z", true}}}

})
