-- Copyright 2019 teverse.com

local uiController = {}
local themeController = require("tevgit:create/controllers/theme.lua")

uiController.createFrame = function(parent, properties, style)
    local gui = engine.construct("guiFrame", parent, properties)
    themeController.addGUI(gui, style and style or "primary")
    return gui
end

uiController.createMainInterface = function()
    local sideBar = uiController.createFrame(nil, {
        size = guiCoord(0,40,1,0),
        position = guiCoord(0,0,0,0)
    })
end

return uiController
