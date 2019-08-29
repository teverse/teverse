-- Copyright 2019 Teverse.com
-- This script includes shorcuts for creating UIs.
-- Any interface created here will be properly themed.

local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local create = function(className, parent, properties, style)
    if not parent then 
        parent = shared.workshop.interface 
    end

    local gui = engine.construct(className, parent, properties)
    themer.registerGui(gui, style and style or "default")
    return gui
end

return {
    create = create,
    
    window = function(parent, title, size, position, dockable, closable)
        local container = create("guiFrame", parent, {
            size = size,
            position = position,
            borderRadius = 4
        }, themer.types.background)
        
        local titleBar = create("guiFrame", container, {
            name = "titleBar",
            size = guiCoord(1, 0, 0, 24)
        }, themer.types.primary)
        
        create("guiTextBox", titleBar, {
            name = "textBox",
            size = guiCoord(1, -12, 0, 20),
            position = guiCoord(0, 6, 0, 2),
            text = title
        }, themer.types.primaryText)
        
        local content = engine.construct("guiFrame", container, {
            name = "content",
            backgroundAlpha = 0,
            size = guiCoord(1, -6, 1, -30),
            position = guiCoord(0, 3, 0, 27)
        })
        
        return container
    end
}