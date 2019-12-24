-- Copyright 2019 Teverse.com

-- Tool Constants:
local toolName = "Scale"
local toolDesc = ""
local toolIcon = "fa:s-expand"

local selection = require("tevgit:workshop/controllers/core/selection.lua")
local history = require("tevgit:workshop/controllers/core/history.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local boundingBoxChangedEvent;
local gridGuideline;
local handles;

local settingsGui = nil

local function updateHandles()
    if handles then
        if selection.box.size == vector3(0,0,0) then
            for _,v in pairs(handles) do
                v[1].size = vector3(0,0,0)
                v[1].opacity = 0
            end
        else
            for _,v in pairs(handles) do
                v[1].position = selection.box.position + selection.box.rotation* ((v[2] * selection.box.size/2) + (v[2]*1.5)) 
                v[1]:lookAt(selection.box.position)
                v[1].rotation = v[1].rotation * quaternion():setEuler(math.rad(90), 0, 0)
                v[1].size = vector3(0.4, 0.4, 0.4)
                v[1].opacity = 1
            end
        end
    end
end

local axes = {"x", "y", "z"}

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

        local gridStep = 1

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

        -- This is used to raycast the user's mouse position to an axis
        gridGuideline = engine.construct("block", workspace, {
            name = "_GridGuideline",
            size = vector3(0, 0, 0),
            colour = colour(1, 1, 1),
            opacity = 0,
            workshopLocked = true,
            castsShadows = false
        })

        handles = {}

        for axisNumber, axis in pairs(axes) do
            for i = -1, 1, 2 do
                local face = vector3(0, 0, 0)
                face[axis] = i

                local handle = engine.construct("block", nil, {
                    name            = "_CreateMode_",
                    castsShadows    = false,
                    opacity         = 0,
                    renderQueue     = 1,
                    doNotSerialise  = true,
                    size            = vector3(0.1, 0.1, 0.1),
                    colour          = colour(axisNumber == 1 and 1 or 0, axisNumber == 2 and 1 or 0, axisNumber == 3 and 1 or 0),
                    emissiveColour  = colour(axisNumber == 1 and 1 or 0, axisNumber == 2 and 1 or 0, axisNumber == 3 and 1 or 0), 
                    workshopLocked  = true
                })

                if (axis == "x" and i == -1) or 
                    (axis == "y" and i == 1) or
                    (axis == "z" and i == 1) then
                    handle.mesh = "primitive:sphere"
                end

                handle:mouseLeftPressed(function()
                    gridGuideline.size = vector3(300, 0.1, 300)

                    local gridVisual = engine.construct("grid", workspace, {
                        step = gridStep,
                        colour = colour(0.1, 0, 0.1),
                        size = 25,
                        rotation = quaternion:setEuler(math.rad(90), 0, 0)
                    })

                    local last = nil
                    local lastDist = nil
                    local dist = nil

                    while engine.input:isMouseButtonDown(enums.mouseButton.left) do
                        -- Position and rotate the invisible guideline to face the camera.
                        -- We use this guideline to raycast with
                        local pos1 = gridGuideline.position
                        pos1[axis] = 0

                        local pos2 = workspace.camera.position
                        pos2[axis] = 0

                        local lookAt = gridGuideline.rotation:setLookRotation( pos1 - pos2 )
                        gridGuideline.rotation =  lookAt * quaternion():setEuler(math.rad(90),0,0)
                        gridGuideline.position = selection.box.position

                        if axis == "y" then
                            gridVisual.rotation = quaternion:setLookRotation( pos1 - pos2 ) * quaternion():setEuler(math.rad(180),0,0)
                        end

                        gridVisual.position = selection.box.position

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

                        if mouseHit and mouseHit.object == gridGuideline then
                            dist = (selection.box.position - mouseHit.hitPosition):length()

                            local target = mouseHit.hitPosition - selection.box.position
                            
                            local didMove = true
                            if last ~= nil then
                                local translateBy = vector3(0, 0, 0)
                                translateBy[axis] = target[axis] - last

                                if gridStep ~= 0 then
                                    translateBy = shared.roundVector3(translateBy, gridStep)
                                    if translateBy[axis] == 0 then
                                        didMove = false
                                    end
                                end

                                if didMove then
                                    for _,v in pairs(selection.selection) do
                                        if type(v.position) == "vector3" and type(v.size) == "vector3" then
                                            v.position = v.position + (translateBy / 2)
                                            translateBy[axis] = math.abs(translateBy[axis])
                                            if lastDist > dist then
                                                translateBy[axis] = -translateBy[axis]
                                            end
                                            local scaleBy = (v.rotation * translateBy)
                                            v.size = v.size + scaleBy
                                        end
                                    end
                                end
                            end

                            if didMove then
                                last = target[axis]
                                lastDist = dist
                            end
                        end

                        wait()
                    end

                    gridVisual:destroy()
                    gridGuideline.size = vector3(0, 0, 0)
                end)

                table.insert(handles, {handle, face})
            end
        end

        boundingBoxChangedEvent = selection.box:changed(updateHandles)
        updateHandles()
    end,

    deactivate = function ()
        if settingsGui then
            settingsGui:destroy()
            settingsGui = nil
        end

        if boundingBoxChangedEvent then
            boundingBoxChangedEvent:disconnect()
            boundingBoxChangedEvent = nil
        end

        if gridGuideline then
            gridGuideline:destroy()
            gridGuideline = nil
        end

        if handles then
            for _,v in pairs(handles) do
                v[1]:destroy()
            end
            handles = nil
        end
    end
}   