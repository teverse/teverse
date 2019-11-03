-- Copyright 2019 Teverse.com

-- Tool Constants:
local toolName = "Hand"
local toolDesc = ""
local toolIcon = "fa:s-hand-pointer"

local selection = require("tevgit:workshop/controllers/core/selection.lua")

local clickEvent = nil

return {
    name = toolName,
    icon = toolIcon,
    desc = toolDesc,

    activate = function()
        -- Set the event listener to a variable so we can disconnect this handler
        -- when the tool is deactivated
        clickEvent = engine.input:mouseLeftPressed(function ( inputObj )
            if not inputObj.systemHandled then
                -- This is not a gui event, let's continue.
                local hit = engine.physics:rayTestScreen(engine.input.mousePosition)
                if hit then
                    -- user has clicked a object in 3d space.
                    if selection.isSelected(hit.object) then
                        -- user clicked a selected object,
                        -- we're gonna turn into drag mode!

                        -- calculate the 'centre' of the selection
                        local bounds = aabb()
                        for _,v in pairs(selection.selection) do
                            bounds:expand(v.position)
                        end
                        local centre = bounds:getCentre()

                        -- calculate the mouse's offset from the centre
                        local mouseOffset = hit.hitPosition - centre

                        -- calculate every selected item's offset from the centre
                        local offsets = {}
                        for _,v in pairs(selection.selection) do
                            offsets[v] = v.position - centre
                        end

                        while engine.input:isMouseButtonDown(enums.mouseButton.left) do
                            -- fire a ray, exclude selected items.
                            local hits, didExclude = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, selection.selection)
                            if (#hits > 0) then
                                local newCentre = hits[1].hitPosition + mouseOffset
                                for _,v in pairs(selection.selection) do
                                    if offsets[v] then
                                        v.position = offsets[v] + newCentre
                                    end
                                end
                            end
                            wait()
                        end

                        print("Centre:", centre, "MouseOffset:", mouseOffset)
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
                end
            end
        end)
    end,

    deactivate = function ()
        if clickEvent then
           clickEvent:disconnect()
           clickEvent = nil 
        end
    end
}   