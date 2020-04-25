-- Copyright 2020- Teverse
-- This script constructs (or builds) the tooltip component

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files

return {
    construct = function(orientation, element, text, ...)
        --[[
            @Description
                Constructor method that initializes the tooltip instance.

            @Params
                String, orientation
                UiBase, element  
                String, text
                {...}, overrides
            
            @Returns
                Instance, tooltip
        ]]--

        local data = {} 
        self = data

        -- Only for horizontal orientation
        local args = {...} -- Hold overrides
        local positionOverride = args[1] or guiCoord(0, 0, 0, 0) -- If not specified, default to guiCoord(0, 0, 0, 0)

        if orientation == "vertical" then -- If orientation is specified to "vertical"
            local container = teverse.construct("guiFrame", {
                parent = teverse.interface
                size = guiCoord(0.1, 0, 0.1, 0),
                position = element.position+guiCoord(-0.02, 0, -0.01, 0),
                backgroundColour = globals.defaultColours.red,
                visible = false,
                zIndex = 200,
                backgroundAlpha = 0
            })

            teverse.construct("guiImage", {
                parent = container,
                size = guiCoord(0, 48, 0, 48),
                position = guiCoord(0.33, 0, -0.15, 0),
                iconId = "caret-up",
                iconType = "faSolid",
                iconColour = globals.defaultColours.secondary,
                backgroundColour = globals.defaultColours.red,
                backgroundAlpha = 0
            })

            local bodyContainer = teverse.construct("guiFrame", {
                parent = container,
                size = guiCoord(0.95, 0, 0.4, 0),
                position = guiCoord(0.025, 0, 0.23, 0),
                backgroundColour = globals.defaultColours.white,
                borderAlpha = 1,
                borderRadius = 5,
                borderWidth = 3,
                borderColour = globals.defaultColours.secondary
            })

            teverse.construct("guiImage", {
                parent = bodyContainer,
                size = guiCoord(0, 16, 0, 16),
                position = guiCoord(0.04, 0, 0.25, 0),
                iconId = "info-circle",
                iconType = "faSolid",
                iconColour = globals.defaultColours.primary,
                backgroundColour = globals.defaultColours.white,
            })

            teverse.construct("guiTextBox", {
                parent = bodyContainer,
                size = guiCoord(0.82, 0, 1, 0),
                position = guiCoord(0.15, 0, 0, 0),
                text = text,
                fontSize = 16,
                textColour = globals.defaultColours.primary,
                backgroundColour = globals.defaultColours.white,
                textAlign = enums.align.middle,
                textWrap = true
            })

            self.display = function() container.visible = true end -- Display tooltip method
            self.hide = function() container.visible = false end -- Hide tooltip method
        
        elseif orientation == "horizontal" then -- If orientation is specified to "horizontal"
            local container = teverse.construct("guiFrame", {
                parent = teverse.interface,
                size = guiCoord(0.13, 0, 0.05, 0),
                position = (element.position+guiCoord(-0.22, 0, 0.24, 0))+positionOverride, -- Shorthand positioning
                backgroundColour = globals.defaultColours.red,
                visible = false,
                zIndex = 200,
                backgroundAlpha = 0
            })

            teverse.construct("guiImage", {
                parent = container,
                size = guiCoord(0, 48, 0, 48),
                position = guiCoord(-0.03, 0, -0.06, 0),
                iconId = "caret-left",
                iconType = "faSolid",
                iconColour = globals.defaultColours.primary,
                backgroundColour = globals.defaultColours.red,
                backgroundAlpha = 0
            })

            local bodyContainer = teverse.construct("guiFrame", {
                parent = container,
                size = guiCoord(0.8, 0, 0.9, 0),
                position = guiCoord(0.133, 0, 0.05, 0),
                backgroundColour = globals.defaultColours.white,
                borderAlpha = 1,
                borderRadius = 5,
                borderWidth = 3,
                borderColour = globals.defaultColours.primary
            })

            teverse.construct("guiImage", {
                parent = bodyContainer,
                size = guiCoord(0, 16, 0, 16),
                position = guiCoord(0.05, 0, 0.3, 0),
                iconId = "fa:s-info-circle",
                iconType = "faSolid",
                iconColour = globals.defaultColours.primary,
                backgroundColour = globals.defaultColours.white,
            })

            teverse.construct("guiTextBox", {
                parent = bodyContainer,
                size = guiCoord(0.82, 0, 1, 0),
                position = guiCoord(0.15, 0, 0, 0),
                text = text,
                fontSize = 16,
                textColour = globals.defaultColours.primary,
                backgroundColour = globals.defaultColours.white,
                textAlign = enums.align.middle,
                textWrap = true
            })

            self.display = function() container.visible = true end -- Display tooltip method
            self.hide = function() container.visible = false end -- Hide tooltip method
        end
        return data
    end
}