print("Hello Client!")

-- The game this is intended for has default scripts disabled, 
-- however: we want to load some core client code anyway

require("tevgit:core/client/debug.lua")
require("tevgit:core/client/chat.lua")
require("tevgit:core/client/playerList.lua")

workspace.camera.position = vector3(0, 25, -15)
workspace.camera:lookAt(vector3(0, 0, 0))
require("tevgit:workshop/controllers/environment/camera.lua")

local boomMode = false
local boomBtn = engine.construct("guiTextBox", engine.interface, {
    text = "Boom Mode Off",
    position = guiCoord(0.5, -70, 0, 10),
    size = guiCoord(0, 140, 0, 24),
    fontSize = 18,
    backgroundColour = colour(0.2, 0.2, 0.25),
    borderRadius = 4,
    align = enums.align.middle
})
boomBtn:on("mouseLeftReleased", function()
    boomMode = not boomMode
    boomBtn.text = boomMode and "Boom Mode On" or "Boom Mode Off"
end)

local function registerBlock(c)
    if c.className == "block" then
        c:once("mouseLeftPressed", function ()
            if c.size == vector3(4, 4, 4) then
                if boomMode then
                    engine.networking:toServer("explodeBlock", c.position.x/4, c.position.y/4, c.position.z/4)
                else
                    engine.networking:toServer("mineBlock", c.position.x/4, c.position.y/4, c.position.z/4)
                end
            end
        end)
    end
end

engine.input:onSync("mouseLeftPressed", function(io)
    if io.systemHandled then return end

	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
    if mouseHit then
        local c = mouseHit.object
        if c.size == vector3(4, 4, 4) then
            if boomMode then
                engine.networking:toServer("explodeBlock", c.position.x/4, c.position.y/4, c.position.z/4)
            else
                engine.networking:toServer("mineBlock", c.position.x/4, c.position.y/4, c.position.z/4)
            end
        end
	end
end)

--workspace:childAdded(registerBlock)
--for _,v in pairs(workspace.children) do registerBlock(v) end