-- Copyright 2020- Teverse
-- This script constructs (or builds) the modal views

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files

return {
    construct = function(size, pos)
        local data = {} 
        self = data

        local container = teverse.construct("guiFrame", {
            parent = teverse.interface,
            name = "_container",
            size = size,
            position = pos,
            backgroundColour = globals.defaultColours.white,
            strokeColour = globals.defaultColours.white,
            strokeRadius = 5,
            strokeWidth = 1,
            dropShadowAlpha = 0.4,
            dropShadowBlur = 2,
            dropShadowColour = colour.rgb(127, 127, 127),
            dropShadowOffset = vector2(0.5, 1),
            zIndex = 100
        })
        container.visible = false

        self.content = container
        self.display = function() container.visible = true end -- Display modal method
        self.hide = function() container.visible = false end -- Hide modal method

        return data
    end
}