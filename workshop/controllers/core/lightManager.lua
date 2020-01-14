-- This file manages lights!
-- It creates a 3d mesh for each light in the scene
-- this is so the developer can easily interact with their lights in the 3d scene...

local controller = {}
controller.lights = {}

local function processChild(child)
    if type(child) == "light" then
        local block = engine.construct("block", workspace, {
            size = vector3(0.5, 0.5, 0.5),
            position = child.position,
            rotation = child.rotation:inverse(),
            workshopLocked = true,
            doNotSerialise = true,
            name = "_CreateMode_",
            mesh = "tevurl:3d/light.glb"
        })

        child:on("changed", function(p, v)
            if p == "position" then
                block[p] = v
            elseif p == "rotation" then
                block[p] = v:inverse()
            end
        end)

        controller.lights[block] = child

        child:onSync("destroying", function()
            controller.lights[block] = nil
            block:destroy()
        end)
    end
end

workspace:on("childAdded", processChild)

return controller