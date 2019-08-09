


local ui = require("tevgit:create/controllers/ui.lua")

local contextMenuController = {}

local activeContextMenu

function contextMenuController.create(options)
    local frame = ui.createFrame(
        ui.workshop.interface, 
        { 
            size = guiCoord(0, 200, 0, 0),
            zIndex = 2 
        }
    )
   
    local position = guiCoord(0, 15, 0, 10)
    local offset = guiCoord(0, 0, 0, 40)
    local size = guiCoord(1, 0, 0, 20)

    for key, data in pairs(options) do        
        local button = ui.create(
            "guiButton", 
            frame, 
            {
                text = key,
                size = size,
                position = position,
                align = enums.align.middleLeft
            }, 
            "primaryText"
        )

        if (data.hotkey) then
           local text = ui.create(
                "guiTextBox", 
                button, 
                {
                    text = data.hotkey,
                    size = guiCoord(1, 0, 1, 0),
                    position = guiCoord(0, -30, 0, 0),
                    align = enums.align.middleRight,
                    handleEvents = false
                }, 
                "secondaryText"
            )
        end

        button:mouseLeftReleased(function()
            if (activeContextMenu == frame) then
                activeContextMenu:destroy()
                activeContextMenu = nil
            end
            data.action()
        end)
        position = position + offset
        frame.size = frame.size + offset
    end

    return frame
end

function contextMenuController.display(contextMenu)
    if (activeContextMenu) then 
        activeContextMenu:destroy()
        activeContextMenu = nil 
    end

    local pos = engine.input.mousePosition
    contextMenu.position = guiCoord(0, pos.x, 0, pos.y)
    if (engine.input.mousePosition.y > engine.input.screenSize.y - contextMenu.size.offsetY) then
        contextMenu.position = contextMenu.position + guiCoord(0, 0, 0, -contextMenu.size.offsetY)
    end
    if (engine.input.mousePosition.x > engine.input.screenSize.x - contextMenu.size.offsetX) then
        contextMenu.position = contextMenu.position + guiCoord(0, -contextMenu.size.offsetX, 0, 0)
    end
    contextMenu.parent = ui.workshop.interface

    --[[contextMenu:mouseUnfocused(function()
        if (activeContextMenu == contextMenu) then
            activeContextMenu:destroy()
            activeContextMenu = nil
        end
    end)]]

    activeContextMenu = contextMenu 
end

function contextMenuController.bind(object, options)
    local listener = object:mouseRightReleased(function()
        contextMenuController.display(
            contextMenuController.create(options)
        )
    end)
    return listener
end

engine.input:mouseLeftReleased(function()
    if (activeContextMenu) then
        local vec2 = engine.input.mousePosition
        local tpLeft = activeContextMenu.absolutePosition
        local btmRight = tpLeft + activeContextMenu.absoluteSize
        if (not (vec2.x > tpLeft.x and vec2.y > tpLeft.y and vec2.x < btmRight.x and vec2.y < btmRight.y)) then
            activeContextMenu:destroy()
            activeContextMenu = nil 
        end
    end
end)

return contextMenuController