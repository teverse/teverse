print("Hello Client!")

-- The game this is intended for has default scripts disabled, 
-- however: we want to load some core client code anyway

require("tevgit:core/client/debug.lua")
require("tevgit:core/client/chat.lua")
require("tevgit:core/client/playerList.lua")

--workspace.camera.position = vector3(0, 15, -10)
--workspace.camera:lookAt(vector3(0, 0, 0))

workspace:childAdded(function(c)
    if c.className == "block" then
        c:once("mouseLeftPressed", function ()
            if c.size == vector3(4, 4, 4) then
                engine.networking:toServer("mineBlock", c.position.x/4, c.position.y/4, c.position.z/4)
            end
        end)
    end
end)