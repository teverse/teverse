-- Copyright 2019 Teverse.com
-- This script includes shorcuts for creating UIs.
-- Any interface created here will be properly themed.

local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")
local dock = require("tevgit:workshop/controllers/ui/core/dock.lua")
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

    button = function(parent, text, size, position, alignment, fontsize, theme)
        if not theme then theme = "primary" end
        local btn = create("guiFrame", parent, {
            size = size,
            position = position,
            borderRadius = 3,
            hoverCursor = "fa:s-hand-pointer",
        }, theme)

        create("guiTextBox", btn, {
            name = "label",
            size = guiCoord(1, -12, 1, -6),
            position = guiCoord(0, 6, 0, 3),
            text = text,
            handleEvents = false,
            align = enums.align.middle,
        }, theme .. "Text")

        return btn
    end,

    -- Prevent backward breaks in older code
    customButton = function(parent, text, size, position, alignment, fontsize, theme)
        if not theme then theme = "primary" end
        local btn = create("guiFrame", parent, {
            size = size,
            position = position,
            borderRadius = 3,
            hoverCursor = "fa:s-hand-pointer",
        }, theme)

        create("guiTextBox", btn, {
            name = "label",
            size = guiCoord(1, -12, 1, -6),
            position = guiCoord(0, 6, 0, 3),
            text = text,
            handleEvents = false,
            align = alignment,
            fontSize = fontsize,
        }, theme .. "Text")

        return btn
    end,
    
    -- if closable is true OR a function, a close button will appear in the title bar.
    -- when clicked, if closable is a function, it is fired after hiding the window.
    window = function(parent, title, size, position, dockable, closable)
        local container = create("guiFrame", parent, {
            size = size,
            name = title,
            position = position,
            cropChildren = false
        }, themer.types.background)
        
        local titleBar = create("guiFrame", container, {
            name = "titleBar",
            position = guiCoord(0, 0, 0, -4),
            size = guiCoord(1, 0, 0, 25),
            borderRadius = 4,
            hoverCursor = "fa:s-hand-pointer"
        }, themer.types.primary)

        titleBar:mouseLeftPressed(function ()
            dock.beginWindowDrag(container, not dockable)
        end)
        
        -- create this to hide radius on bottom of titlebar
        create("guiFrame", titleBar, {
            size = guiCoord(1, 0, 0, 3),
            position = guiCoord(0, 0, 1, -3)
        }, themer.types.primary)

        create("guiTextBox", titleBar, {
            name = "textBox",
            size = guiCoord(1, -12, 0, 20),
            position = guiCoord(0, 6, 0, 2),
            text = title,
            handleEvents = false
        }, themer.types.primaryText)

        if closable then
            local closeBtn = create("guiImage", titleBar, {
                position = guiCoord(1, -22, 0, 3),
                size = guiCoord(0, 19, 0, 19),
                texture = "fa:s-window-close",
                imageAlpha = 0.5,
                hoverCursor = "fa:s-hand-pointer"
            }, "primaryImage")

            closeBtn:mouseLeftReleased(function ()
                container.visible = false
                if type(closable) == "function" then
                    closable()
                end
            end)
        end
        
        local content = engine.construct("guiFrame", container, {
            name = "content",
            backgroundAlpha = 0,
            size = guiCoord(1, -12, 1, -27),
            position = guiCoord(0, 3, 0, 24),
            cropChildren = false
        })
        
        return container
    end
}