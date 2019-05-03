-- Copyright 2019 teverse.com

local uiController = {}
local themeController = require("tevgit:create/controllers/theme.lua")
local toolsController = require("tevgit:create/controllers/tool.lua")

uiController.create = function(className, parent, properties, style)
    local gui = engine.construct(className, parent, properties)
    themeController.add(gui, style and style or "default")
    return gui
end

uiController.createFrame = function(parent, properties, style)
    local gui = uiController.create("guiFrame", parent, properties, style)
    return gui
end

uiController.createMainInterface = function()
    local sideBar = uiController.createFrame(engine.workshop.interface, {
        name = "toolbars",
        size = guiCoord(0,40,1,0),
        position = guiCoord(0,0,0,0)
    }, "main")
    print("created main ui")
    toolsController.container = sideBar
    toolsController.ui = uiController
end

return uiController
