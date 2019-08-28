local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local window = ui.window(shared.workshop, 
   "Settings", 
   guiCoord(0, 400, 0, 300), --size
   guiCoord(0.5, -200, 0.5, -150), --pos
   false, --dockable
   true -- hidable
)

local sideBar = ui.create("guiFrame", window, {
   size = guiCoord(0.35, 0, 1, 0)
}, "secondary")