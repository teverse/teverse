


local controller = {

    contextLastOpenedAt = nil,
    activeContextMenu = nil

}

local ui = require("tevgit:create/controllers/ui.lua")

local function mouseOutOfBounds(tpLeft, btmRight)
    local vec2 = engine.input.mousePosition
    return (not (vec2.x > tpLeft.x and vec2.y > tpLeft.y and vec2.x < btmRight.x and vec2.y < btmRight.y))
end

function controller.create(options)  
    local frame = engine.guiFrame()
    frame.size = guiCoord(0, 200, 0, 0)
    frame.cropChildren = false 
    frame.zIndex = 2
    ui.theme.add(frame, "main")

    local position = guiCoord(0, 15, 0, 10)
    local size = guiCoord(1, 0, 0, 20)
    local offsetY = guiCoord(0, 0, 0, 40)

    for key, data in next, options do
        local option = data.subOptions and engine.guiTextBox() or engine.guiButton()
        option.position = position
        option.size = size
        option.align = enums.align.middleLeft
        option.cropChildren = false 
        option.text = key
        ui.theme.add(option, "primaryText")
        if (data.subOptions) then
            local subframe = controller.create(data.subOptions)
            ui.theme.add(subframe, "secondary")
            subframe.position = guiCoord(1, -15, 0, -10)
            subframe.visible = false 
            subframe.parent = option

            local isShowing = false
            
            option:mouseFocused(function()
                if (not isShowing) then
                    isShowing = true 
                    
                    subframe.position = guiCoord(1, -15, 0, -10)
                    if (engine.input.mousePosition.y > engine.input.screenSize.y - subframe.size.offsetY) then
                        subframe.position = subframe.position + guiCoord(0, 0, 0, -(subframe.size.offsetY - 40))
                    end
                    if (engine.input.mousePosition.x > engine.input.screenSize.x - frame.size.offsetX) then
                        subframe.position = subframe.position + guiCoord(-1, -frame.size.offsetX, 0, 0)
                    end

                    subframe.visible = true
                    repeat wait() 
                    until controller.activeContextMenu == nil or (
                        mouseOutOfBounds(subframe.absolutePosition, subframe.absolutePosition + subframe.absoluteSize) 
                        and mouseOutOfBounds(option.absolutePosition, option.absolutePosition + option.absoluteSize)
                    )
                    if (controller.activeContextMenu ~= nil) then
                        isShowing = false
                        subframe.visible = false
                    end
                end
            end)
        else
            option:mouseLeftReleased(function()
                if (frame and controller.activeContextMenu and (controller.activeContextMenu == frame or frame:isDescendantOf(controller.activeContextMenu))) then
                    controller.activeContextMenu:destroy()
                    controller.activeContextMenu = nil 
                    data.action()
                end
            end)
        end
        if (data.subOptions or data.hotkey) then
            local subtext = engine.guiTextBox()
            subtext.text = data.hotkey or ">"
            subtext.size = guiCoord(1, 0, 1, 0)
            subtext.position = guiCoord(0, -30, 0, 0)
            subtext.handleEvents = false 
            subtext.align = enums.align.middleRight
            ui.theme.add(subtext, "secondaryText")
            subtext.parent = option
        end
        frame.size = frame.size + offsetY
        position = position + offsetY
        option.parent = frame 
    end

    return frame
end

function controller.display(contextMenu)
    if (controller.activeContextMenu) then 
        controller.activeContextMenu:destroy()
        controller.activeContextMenu = nil 
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
    contextLastOpenedAt = engine.input.mousePosition
    controller.activeContextMenu = contextMenu 
end

function controller.bind(object, options)
    local listener = object:mouseRightReleased(function()
        if type(options) == "function" then
            controller.display(controller.create(options()))
        else
            controller.display(controller.create(options))
        end
    end)
    return listener
end

engine.input:mouseLeftReleased(function()
    if (controller.activeContextMenu) then
        local tpLeft = controller.activeContextMenu.absolutePosition
        local btmRight = tpLeft + controller.activeContextMenu.absoluteSize
        if (mouseOutOfBounds(tpLeft, btmRight)) then
            controller.activeContextMenu:destroy()
            controller.activeContextMenu = nil 
        end
    end
end)

return controller