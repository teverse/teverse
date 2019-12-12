print("Hello Client!")

-- The game this is intended for has default scripts disabled, 
-- however: we want to load some core client code anyway

require("tevgit:core/client/debug.lua")
require("tevgit:core/client/chat.lua")
require("tevgit:core/client/playerList.lua")
require("tevgit:core/client/characterController.lua")

workspace.camera.position = vector3(0, 15, -10)
workspace.camera:lookAt(vector3(0, 0, 0))

local function registerBlock(c)
    if c.className == "block" then
        c:once("mouseLeftPressed", function ()
            if c.size == vector3(4, 4, 4) then
                print("mining", c.position.x/4, c.position.y/4, c.position.z/4)
                engine.networking:toServer("mineBlock", c.position.x/4, c.position.y/4, c.position.z/4)
            end
        end)
    end
end

workspace:childAdded(registerBlock)
for _,v in pairs(workspace.children) do registerBlock(v) end