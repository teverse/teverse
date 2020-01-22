local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local window = ui.window(shared.workshop.interface, "Publish Game to Teverse",
    guiCoord(0, 620, 0, 500),
    guiCoord(0.5, -310, 0.5, -250),
    false,
    true, 
    false
)

local container = ui.create("guiFrame", window.content, {
    size = guiCoord(0, 0, 0, -18),
    position = guiCoord(0, 0, 0, 18)
}, "background")



return window