-- Copyright 2020 Teverse.com
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

local activeTooltip = nil

return {
    tooltip = function ( gui, text, delay )
        if gui:isA("guiBase") then
            if not delay then delay = 0.4 end
            return gui:on("mouseFocused", function ()
                local tooltip = create("guiTextBox", shared.workshop.interface, {
                    position = guiCoord(0, engine.input.mousePosition.x + 16, 0, engine.input.mousePosition.y),
                    text = text,
                    fontSize = 16,
                    align = enums.align.middle,
                    borderRadius = 0,
                    borderAlpha = 1,
                    zIndex = 5000,
                    handleEvents = false,
                    visible = false
                }, "primaryVariant")

                local textDimensions = tooltip.textDimensions
                tooltip.size = guiCoord(0, textDimensions.x + 10, 0, textDimensions.y + 4)

                gui:once("mouseUnfocused", function()
                    tooltip:destroy()
                end)

                wait(delay)
                if tooltip and tooltip.alive then
                    tooltip.visible = true
                end
            end)
        end
    end,

    create = create,

    button = function(parent, text, size, position, theme)
        if not theme then theme = "primary" end
        local btn = create("guiFrame", parent, {
            size = size,
            position = position,
            borderRadius = 0,
            hoverCursor = "fa:s-hand-pointer"
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

    -- if closable is true OR a function, a close button will appear in the title bar.
    -- when clicked, if closable is a function, it is fired after hiding the window.
    window = function(parent, title, size, position, dockable, closable, dragable)
        local container = create("guiFrame", parent, {
            size = size,
            name = title,
            position = position,
            cropChildren = false,
            borderColour = colour:fromRGB(55, 59, 64),
            borderWidth = 2,
            borderAlpha = 1,
        }, themer.types.background)

        container:on("changed", function (property, value)
            if property == "visible" and not value then
                dock.undock(container) -- just in case
            end
        end)

        local titleBar = create("guiFrame", container, {
            name = "titleBar",
            position = guiCoord(0, -1, 0, -4),
            size = guiCoord(1, 2, 0, 25),
            borderRadius = 0,
            hoverCursor = "fa:s-hand-pointer"
        }, themer.types.primary)

        titleBar:mouseLeftPressed(function ()
            if dragable == false then return end -- Backwards compatibility
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
            cropChildren = false,
        })

        return container
    end,

    -- Creates a full screen prompt
    -- Prevents user from doing anything until they acknowledge the prompt
    -- if callback is nil, the function yields until the user continues
    -- if callback is a function, it is ran when the user continues
    prompt = function ( message, callback )
        local content = create("guiFrame", shared.workshop.interface, {
            name = "_prompt",
            backgroundAlpha = 0.9,
            backgroundColour = colour:black(),
            size = guiCoord(1, 0, 1, 0),
            position = guiCoord(0, 0, 0, 0),
            zIndex = 5000
        }, "background")

        if shared.developerMode then
            content.handleEvents = false
            create("guiTextBox", content, {
                name = "disclaimer",
                size = guiCoord(1, 0, 0, 14),
                position = guiCoord(0, 0, 1, -14),
                text = "Developer mode is enabled, this prompt has not captured your mouse input, bg opacity is also decreased.",
                handleEvents = false,
                align = enums.align.middle,
                fontSize = 14
            }, "backgroundText")

            content.backgroundAlpha = 0.75
        end

        local container = create("guiFrame", content, {
            size = guiCoord(0.4, 0, 0.4, 0),
            position = guiCoord(0.3, 0, 0.3, 0),
            cropChildren = false,
            borderRadius = 0,
            handleEvents = false
        }, themer.types.primary)

        local text = create("guiTextBox", container, {
            name = "disclaimer",
            size = guiCoord(1, -20, 1, -20),
            position = guiCoord(0, 10, 0, 10),
            text = message,
            handleEvents = false,
            align = enums.align.middle,
            fontSize = 21
        }, "primaryText")

        local textDimensions = text.textDimensions
        container.size = guiCoord(0, textDimensions.x + 20, 0, textDimensions.y + 20)
        container.position = guiCoord(0.5, -(textDimensions.x + 20)/2, 0.5, -(textDimensions.y + 20)/2)

        local continue = create("guiTextBox", content, {
            size = guiCoord(0, textDimensions.x + 20, 0, 40),
            position = guiCoord(0.5, -(textDimensions.x + 20)/2, 0.5, (textDimensions.y/2 + 5)),
            cropChildren = false,
            zIndex = 2,
            text = "Continue",
            align = enums.align.middle,
            fontFile = "local:OpenSans-Bold.ttf"
        }, themer.types.primaryVariant)

        if not callback then
            local acknowledged = false
            continue:once("mouseLeftPressed", function() acknowledged = true end)
            repeat wait() until acknowledged
            content:destroy()
            return true
        else
            continue:once("mouseLeftPressed", function()
                if type(callback) == "function" then
                    callback()
                end
                content:destroy()
            end)
        end
    end
}
