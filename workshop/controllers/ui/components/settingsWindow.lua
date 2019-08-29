local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local window = ui.window(shared.workshop.interface, 
   "Settings", 
   guiCoord(0, 600, 0, 500), --size
   guiCoord(0.5, -300, 0.5, -250), --pos
   false, --dockable
   true -- hidable
)

local sideBar = ui.create("guiFrame", window.content, {
   size = guiCoord(0.35, 0, 1, 0)
}, "primaryVariant")


-- Debugging purposes only:
local themePreview = require("tevgit:workshop/controllers/ui/components/themePreviewer.lua")

local themePage = ui.create("guiScrollView", window.content, {
   size = guiCoord(0.65, 0, 1, 0),
   position = guiCoord(0.35, 0, 0, 0)
}, "background")

themePreview.parent = themePage
