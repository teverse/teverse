function draggableUi (uiToMove, activator)
    local mouseIsDown = false
    if not uiToMove then
        return error("Failed to create draggableUi: No UI provided!")
    end
    if not activator then
        activator = uiToMove
    end
    local evA = activator:on("mouseLeftDown", function( mousePos )
        mouseIsDown = true
        local startPos = uiToMove.position:get2D(teverse.input.screenSize)
        local offset = teverse.input.mousePosition - startPos

        spawn(function ()
            while mouseIsDown do
                -- Calculate new position relative to the mouse pointer
                local mousePos = teverse.input.mousePosition
                local targetPos = mousePos - offset

                uiToMove.position = guiCoord(0, targetPos.x, 0, targetPos.y)
                sleep()
            end
        end)
    end) 

    local evB = teverse.input:on("mouseLeftUp", function( mousePosition )
        mouseIsDown = false
    end) 
end
return {
    draggableUi = draggableUi

}