-- Copyright 2020 Teverse.com

-- Tool Constants:
local toolName = "Rotate"
local toolDesc = ""
local toolIcon = "fa:s-redo"

local selection = require("tevgit:workshop/controllers/core/selection.lua")
local history = require("tevgit:workshop/controllers/core/history.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local boundingBoxChangedEvent;
local handles;
local hoverLine;

local settingsGui = nil
local dragging = false

local function updateHandles()
    if dragging then return end
    if handles then
        if selection.box.size == vector3(0,0,0) then
            for _,v in pairs(handles) do
                v[1].size = vector3(0,0,0)
                v[1].opacity = 0
            end
        else
            local radius = math.max(selection.box.size.x, math.max(selection.box.size.y, selection.box.size.z)) + 1
            for _,v in pairs(handles) do
                v[1].position = selection.box.position
                v[1].size = vector3(radius, 0.005, radius)
                --[[if v[3] == "x" then
                    local rot = v[1].rotation:getEuler()
                    print(rot.y)
                    v[1].rotation = quaternion:setEuler(math.rad(90), rot.y, 0)
                end--]]
            end
        end
    end
end

local axes = {"x", "y", "z"}

local function getHandleIndex(obj) 
    for i,v in pairs(handles) do
        if v[1] == obj then
            return i
        end
    end

    return nil
end

local function stepHandler()
    if dragging then return end

    if hoverLine and hoverLine.alive then
        for _,v in pairs(handles) do
            v[1].opacity = 0
        end

        local hit = engine.physics:rayTestScreen(engine.input.mousePosition)
        if hit and hit.object.name == "_CreateMode_Handle" then
            hoverLine.positionA = hit.hitPosition
            hoverLine.positionB = hit.object.position
            local handleI = getHandleIndex(hit.object)
            local face = handles[handleI][2]

            hoverLine.positionB[handles[handleI][3]] = hoverLine.positionA[handles[handleI][3]]
            hit.object.opacity = 0.5
            --hoverLine.colour = colour(face.x == 1 and 1 or 0, face.y == 1 and 1 or 0, face.z == 1 and 1 or 0)
        else
            hoverLine.positionA = vector3()
            hoverLine.positionB = vector3()
        end
    end
end

return {
    name = toolName,
    icon = toolIcon,
    desc = toolDesc,

    activate = function()
        hoverLine = engine.construct("line", workspace, {name = "_CreateMode_"})

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

        local gridStep = 10

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

        handles = {}
        local radius = math.max(selection.box.size.x, math.max(selection.box.size.y, selection.box.size.z))

        for axisNumber, axis in pairs(axes) do
            local face = vector3(0, 0, 0)
            face[axis] = 1

            local handle = engine.construct("block", nil, {
                name            = "_CreateMode_Handle",
                castsShadows    = false,
                opacity         = 0,
                renderQueue     = 1,
                doNotSerialise  = true,
                size            = vector3(0.1, 0.1, 0.1),
                colour          = colour(axisNumber == 1 and 1 or 0, axisNumber == 2 and 1 or 0, axisNumber == 3 and 1 or 0),
                emissiveColour  = colour(axisNumber == 1 and 1 or 0, axisNumber == 2 and 1 or 0, axisNumber == 3 and 1 or 0), 
                workshopLocked  = true,
                rotation        = quaternion:setEuler((axisNumber == 1 or axisNumber == 3) and math.rad(90) or 0, axisNumber == 1 and math.rad(90) or 0, 0),
                mesh            = "primitive:cylinder"
            })

            handle:mouseLeftPressed(function(inputObj, handleHit)
                dragging = true
                if steppedEvent then
                    steppedEvent:disconnect()
                    steppedEvent = nil
                end

                local objects = {}
                for _,v in pairs(selection.selection) do
                    if type(v.rotation) == "quaternion" then
                        objects[v] = v.rotation
                    end
                end

                local line2 = engine.construct("line", workspace)
                line2.positionA = handle.position

                local startNormal = (handleHit.hitPosition - handle.position):normal()
                local startQuat = quaternion:setLookRotation(startNormal)
                local startEuler = startQuat:getEuler()

                local lastRot = startEuler[axis]

                hoverLine.positionA = handle.position
                hoverLine.positionB = handle.position + (startNormal * radius)
                handle.size = vector3(1000, 0.01, 1000)

                local gui = engine.construct("guiTextBox", shared.workshop.interface, {
                    text = "",
                    backgroundAlpha = 0,
                    fontFile = "local:OpenSans-Bold.ttf",
                    textColour = colour:black(),
                    textAlpha = 0.3,
                    visible = false,
                    cropChildren = false
                })
                engine.construct("guiTextBox", gui, {
                    name = "shadow",
                    text = "",
                    backgroundAlpha = 0,
                    fontFile = "local:OpenSans-Bold.ttf",
                    position = guiCoord(0, 1, 0, 1),
                    zIndex = -1
                })
                
                handle.opacity = 0
                while engine.input:isMouseButtonDown(enums.mouseButton.left) do
                    local hits = engine.physics:rayTestScreenAllHits(engine.input.mousePosition)
                    local hit = nil
                    for _,v in pairs(hits) do
                        if v.object == handle then
                            hit = v
                            goto skip
                        end
                    end

                    ::skip::
                    if hit then
                        local normal = (hit.hitPosition - handle.position):normal()
                        local quat = quaternion:setLookRotation(normal)
                        local euler = quat:getEuler()
                        euler[axis] = shared.round(euler[axis], math.rad(gridStep))
                        local roundedQuat = quaternion:setEuler(euler)
                        local roundedNormal = roundedQuat * vector3(0, 0, 1)

                        if lastRot ~= euler[axis] then
                            line2.positionB = handle.position + (roundedNormal * radius)

                            local visible, vec2 = workspace.camera:worldToScreen(line2.positionB)
                            if visible then 
                                gui.visible = true
                                gui.position = guiCoord(0, vec2.x, 0, vec2.y)
                                gui.text = tostring(euler)--"" .. shared.roundDp(math.deg(euler[axis]), 1)
                                gui.shadow.text = gui.text
                            else
                                gui.visible = false
                            end

                            local rotateByEuler = vector3(0, 0, 0)
                            rotateByEuler[axis] = euler[axis]
                            local rotateBy = quaternion:setEuler(rotateByEuler)
                            for v, r in pairs(objects) do
                                v.rotation = r * quat
                            end

                            lastRot = euler[axis]
                        end
                    end

                    wait()
                end

                gui:destroy()
                line2:destroy()

                if not steppedEvent then
                    steppedEvent = engine:onSync("stepped", stepHandler) 
                end

                dragging = false
                updateHandles()
            end)

            table.insert(handles, {handle, face, axis})
        end

        steppedEvent = engine:onSync("stepped", stepHandler)

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

        if hoverLine then
            hoverLine:destroy()
            hoverLine = nil
        end

        if steppedEvent then
            steppedEvent:disconnect()
            steppedEvent = nil
        end

        if handles then
            for _,v in pairs(handles) do
                v[1]:destroy()
            end
            handles = nil
        end
    end
}   