-- Copyright 2020 Teverse.com

-- Tool Constants:
local toolName = "Hand"
local toolDesc = ""
local toolIcon = "fa:s-hand-pointer"

local selection = require("tevgit:workshop/controllers/core/selection.lua")
local history = require("tevgit:workshop/controllers/core/history.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local clickEvent = nil
local keyEvent = nil
local settingsGui = nil
local isDragging = false

return {
    name = toolName,
    icon = toolIcon,
    desc = toolDesc,

    activate = function()

        settingsGui = ui.create("guiFrame", shared.workshop.interface["_toolBar"], {
            size = guiCoord(0, 120, 0, 28),
            position = guiCoord(0, 80, 0, 0),
            backgroundAlpha = 0.8,
            borderRadius = 4
        }, "primary")

        ui.create("guiTextBox", settingsGui, {
            size = guiCoord(0.6, 0, 0, 18),
            position = guiCoord(0, 5, 0, 5),
            text = "Grid Step",
            fontSize = 18,
            textAlpha = 0.8 
        }, "primaryText")

        local gridStep = 0.25

        local gridStepInput = ui.create("guiTextBox", settingsGui, {
            size = guiCoord(0.4, -6, 0, 18),
            position = guiCoord(0.6, 3, 0, 5),
            text = tostring(gridStep),
            fontSize = 18,
            textAlpha = 0.8,
            borderRadius = 4,
            align = enums.align.middle,
            readOnly = false
        }, "primaryVariant")

        gridStepInput:on("changed", function()
            gridStep = tonumber(gridStepInput.text) or 0 
        end)

        local offsets = {}
        keyEvent = engine.input:keyPressed(function( inputObj )
            if inputObj.key == enums.key.r and isDragging then
                local targetRot = quaternion:setEuler(0,math.rad(-45),0)
                for _,v in pairs(selection.selection) do
                    if offsets[v] then
                        offsets[v][2] = offsets[v][2] * targetRot
                        v.rotation = offsets[v][2]
                    end
                end
            end
        end)

        -- Set the event listener to a variable so we can disconnect this handler
        -- when the tool is deactivated
        clickEvent = engine.input:mouseLeftPressed(function ( inputObj )
            if not inputObj.systemHandled then
                -- This is not a gui event, let's continue.
                local hit = engine.physics:rayTestScreen(engine.input.mousePosition)
                if hit and not hit.object.workshopLocked then
                    -- user has clicked a object in 3d space.
                    if selection.isSelected(hit.object) then
                        -- user clicked a selected object,
                        -- we're gonna turn into drag mode!

                        -- calculate the 'centre' of the selection
                        local bounds = aabb()

                        if #selection.selection > 0 then
                            bounds.min = selection.selection[1].position
                            bounds.max = selection.selection[1].position
                        end

                        for _,v in pairs(selection.selection) do
                            local size = v.size or vector3(0,0,0)
                            bounds:expand(v.position + (size/2))
                            bounds:expand(v.position - (size/2))
                        end

                        local centre = bounds:getCentre()

                        -- calculate the mouse's offset from the centre
                        local mouseOffset = hit.hitPosition - centre

                        -- calculate every selected item's offset from the centre
                        offsets = {}
                        for _,v in pairs(selection.selection) do
                            --offsets[v] = v.position - centre
                            local relative = quaternion(0, 0, 0, 1) * v.rotation;	
						    local positionOffset = (relative*quaternion(0, 0, 0, 1)):inverse() * (v.position - centre) 
						    offsets[v] = {positionOffset, relative}
                        end
                        
                        -- tell history to monitor changes we make to selected items 
                        history.beginAction(selection.selection, "Hand tool drag")

                        local grid = engine.construct("grid", workspace, {
                            step = gridStep,
                            colour = colour(0.1, 0, 0.1),
                            size = 12,
                            rotation = quaternion:setEuler(math.rad(90), 0, 0)
                        })

                        isDragging = true

                        while engine.input:isMouseButtonDown(enums.mouseButton.left) do
                            -- fire a ray, exclude selected items.
                            local hits, didExclude = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, selection.selection)
                            if (#hits > 0) then
                                local newCentre = hits[1].hitPosition - mouseOffset
                                if gridStep ~= 0 then
                                    newCentre = shared.roundVector3(newCentre, gridStep)
                                end
                                local avgPos = vector3(0,0,0)
                                local minY = hits[1].hitPosition.y
                                for _,v in pairs(selection.selection) do
                                    if offsets[v] then
                                        v.position = newCentre + (offsets[v][2] * offsets[v][1])

                                        -- Calculate the lowest point in the selection:
                                        local size = v.size or vector3(0,0,0)
                                        minY = math.min(minY, v.position.y - (size.y/2))
                                        avgPos = avgPos + v.position
                                    end
                                end
                                
                                -- If the lowest object is less than the mouse's position
                                if minY < hits[1].hitPosition.y then
                                    local offsetBy = vector3(0, hits[1].hitPosition.y - minY, 0)
                                    
                                    -- increase height of each selected object so they're above the hovered position.
                                    for _,v in pairs(selection.selection) do
                                        if offsets[v] then
                                            v.position = v.position + offsetBy
                                        end
                                    end
                                end
                                
                                grid.position = (avgPos / #selection.selection) + vector3(0, 0.1, 0)
                            end
                            wait()
                        end
                        
                        isDragging = false

                        history.endAction()

                        grid:destroy()
                    else
                        -- user clicked an unselected object, let's select it
                        if engine.input:isKeyDown(enums.key.leftShift) then
                            -- holding shift, so we append the clicked object to selection
                            selection.addSelection(hit.object)
                        else
                            -- we override the user's selection here
                            selection.setSelection(hit.object)
                        end
                    end
                else
                    selection.setSelection({})
                end
            end
        end)
    end,

    deactivate = function ()
        if settingsGui then
            settingsGui:destroy()
            settingsGui = nil
        end

        if keyEvent then
            keyEvent:disconnect()
            keyEvent = nil
        end

        if clickEvent then
           clickEvent:disconnect()
           clickEvent = nil 
        end
    end
}   
