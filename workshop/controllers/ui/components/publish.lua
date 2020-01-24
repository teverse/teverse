local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")
local http = shared.workshop:getHttp()
local user = engine:isAuthenticated()

local i, x, y = 0, 0, 0

local data = http:get("https://teverse.com/api/users/"..(user[3].id).."/games") -- returns 404

local window = ui.window(shared.workshop.interface, "Publish Game to Teverse",
    guiCoord(0, 620, 0, 500),
    guiCoord(0.5, -310, 0.5, -250),
    false,
    true, 
    false
)

local container = ui.create("guiScrollView", window.content, {
    size = guiCoord(0.97, 0, 0.875, 0),
    canvasSize = guiCoord(0,0,1,450),
    position = guiCoord(0.02, 0, 0.1, 0),
    scrollBarColour = colour:fromRGB(255, 255, 255)
}, "background")

ui.create("guiTextBox", window, {
    position = guiCoord(0, 15, 0, 35),
    size = guiCoord(0.5, 0, 0.5, 0),
    text = "Choose a place to overwrite or create a new one."
}, "backgroundText")

-- Visualization
--[[
local data = {
    {
        ["id"] = "AJz4x",
        ["ownerId"] = "zME5M",
        ["ownerName"] = "Jay",
        ["name"] = "Testing Grounds",
        ["createdTimestamp"] = "2018-07-04T20:39:33+00:00",
        ["serverCount"] = 0,
        ["thumbnail"] = "img/newThumb2.jpg"
    },
}
]]--

local title
for key,value in pairs(data) do
    print(key, value)
    local placeContainer = ui.create("guiFrame", container, {
        position = guiCoord(x, 0, y, 0),
        size = guiCoord(0.2, 0, 0.25, 0),
        cropChildren = true
    }, "primary")

    if i == 0 then 
        title = "+ CREATE"
    elseif i > 0 then
        title = "Game "..i
    end
    
    local containerButton = ui.button(placeContainer, title, guiCoord(1, 0, 1, 0), guiCoord(0, 0, 0, 0), "secondary")
    containerButton:mouseLeftPressed(function ()
        print("CLICKED")
        shared.workshop:publishDialogue()  -- temp     
	end)
    x = x + 0.23
    if x >= 0.92 then x = 0 y = y + 0.29 end
    i = i + 1
end


return window