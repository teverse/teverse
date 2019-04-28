-- Copyright 2019 teverse.com

local uiController = {}
local themeController = require("tevcore:create/controllers/theme.lua")
local toolsController = require("tevcore:create/controllers/tool.lua")

uiController.createFrame = function(parent, properties, style)
    local gui = engine.construct("guiFrame", parent, properties)
    themeController.addGUI(gui, style and style or "default")
    return gui
end

uiController.createMainInterface = function()
    local sideBar = uiController.createFrame(engine.workshop.interface, {
        name = "toolbars",
        size = guiCoord(0,40,1,0),
        position = guiCoord(0,0,0,0)
    }, "main")
    
    toolsController.container = sideBar
end

return uiController
