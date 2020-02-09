local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")
local http = shared.workshop:getHttp()
local user = engine:isAuthenticated()

local i, x, y = 0, 0, 0

--local data = http:get("https://teverse.com/api/users/"..(user[3].id).."/games") -- returns 404

local data = http:get("https://teverse.com/api/users/958102cf-d0f4-4f92-b1eb-75a2e2202f98/games")
data = engine.json:decode(data["body"])

-- https://teverse.com/api/games POST
--[[
    {
        "name": string,
        "description": string,
        "maxClients": 0,
        "active": true,
        "featured": true
    }
]]--

-- PUT /api/games/{id}/game
    -- returns game's .tev serialized format

-- PUT /api/games/{id}
    -- Body is the games object (name, description. etc)

-- engine.http:request("PUT","URL","BODY",{["Content-Type"] = "application/json", ["HEADER"] = "EXAMPLE"})

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
{
    {
        "id":"08d7aa89-c822-fa38-4323-95c6d3df2dd8",
        "name":"Test",
        "description":"",
        "ownerId":null,
        "createdAt":"2020-02-05T22:21:44.118104",
        "updatedAt":"0001-01-01T00:00:00",
        "maxClients":1,
        "active":false,
        "featured":false,
        "thumbnail":"img/test.png"
    },
    {
        "id":"97893758-3f94-48f0-899a-ecf1eca5199a",
        "name":"Procedural Miner",
        "description":"Here's a place that I test multiplayer and stuff. Yeah its bad.",
        "ownerId":null,
        "createdAt":"2019-12-01T19:14:51.197471",
        "updatedAt":"2019-12-01T19:14:51.197518",
        "maxClients":100,
        "active":true,
        "featured":false,
        "thumbnail":"asset/image/08d7aa83-fbf3-6dad-3b38-d416951ede76"
    }
}
]]--


local newPlaceContainer = ui.create("guiFrame", container, {
    position = guiCoord(x, 0, y, 0),
    size = guiCoord(0.2, 0, 0.25, 0),
    cropChildren = true
}, "primary")

local newContainerButton = ui.button(newPlaceContainer, "+ CREATE", guiCoord(1, 0, 1, 0), guiCoord(0, 0, 0, 0), "primary")
newContainerButton:mouseLeftPressed(function()
    shared.workshop:publishDialogue()  
end)
x = x + 0.23
i = i + 1



for _, place in pairs(data) do

    local placeContainer = ui.create("guiImage", container, {
        position = guiCoord(x, 0, y, 0),
        size = guiCoord(0.2, 0, 0.25, 0),
        cropChildren = true,
        texture = "tevurl:"..place["thumbnail"]
    }, "primary")
    
    local containerButton = ui.create("guiButton", placeContainer, {
        position = guiCoord(0, 0, 0, 0), 
        size = guiCoord(1, 0, 1, 0),
        visible = true,
        zIndex = 25,
        backgroundAlpha = 0
    }, "secondary")

    local popupContainer = ui.create("guiFrame", placeContainer, {
        position = guiCoord(0, 0, 1, 0),
        size = guiCoord(1.1, 0, 0.25, 0),
        cropChildren = true,
        zIndex = 20
    }, "secondary")

    ui.create("guiTextBox", popupContainer, {
        position = guiCoord(0, 0, 0, 0),
        size = guiCoord(1, 0, 1, 0),
        text = "UPDATE",
        fontSize = 14,
        align = enums.align.middle,
        zIndex = 21,
        backgroundAlpha = 0
    }, "primary")

    containerButton:on("mouseFocused", function()
        engine.tween:begin(popupContainer, 0.1, {
            position = guiCoord(0, 0, 0.75, 0)
        }, "inOutQuad")
    end)

    containerButton:on("mouseUnfocused", function()
        engine.tween:begin(popupContainer, 0.1, {
            position = guiCoord(0, 0, 1, 0)
        }, "inOutQuad")
    end)

    containerButton:mouseLeftPressed(function()
        print("CLICKED")
        shared.workshop:publishDialogue()  -- temp     
    end)

    -- Prevent name overflow (15 character max)
    local title = place["name"]
    if string.len(place["name"]) >= 18 then
        title = string.sub(title, 1, 15).."..."
    end
    
    ui.create("guiTextBox", container, {
        position = guiCoord(x, 0, y+0.25, 0),
        size = guiCoord(0.5, 0, 0.5, 0),
        text = title,
        fontSize = 17,
        wrap = true,
        zIndex = 10
    }, "backgroundText")

    x = x + 0.23
    if x >= 0.92 then x = 0 y = y + 0.29 end
    i = i + 1
end


return window