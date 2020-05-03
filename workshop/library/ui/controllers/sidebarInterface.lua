-- Copyright 2020- Teverse
-- This script constructs (or builds) the sidebar controller

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files
local toolTip = require("tevgit:workshop/library/ui/components/toolTip.lua") -- UI component

return {
    construct = function(idValue)
        --[[
            @Description
                Constructor method that initializes the sidebar instance.

            @Params
                String, idValue

            @Returns
                Instance, sidebar
        ]]--

        local data = {} 
        self = data
        self.id = idValue -- Unique Indentifier
        self.pages = {} -- Where we store our pages for sidebar

        teverse.construct("guiFrame", {
            parent = teverse.interface,
            size = guiCoord(0.04, 0, 0.015, 0),
            position = guiCoord(0, 0, 0.05, 0),
            backgroundColour = globals.defaultColours.secondary,
        })

        teverse.construct("guiFrame", {
            parent = teverse.interface,
            size = guiCoord(0.04, 0, 0.015, 0),
            position = guiCoord(0, 0, 0.24, 0),
            backgroundColour = globals.defaultColours.secondary,
        })
    
        local toolsContainer = teverse.construct("guiFrame", {
            parent = teverse.interface,
            size = guiCoord(0.04, 0, 0.18, 0),
            position = guiCoord(0, 0, 0.065, 0),
            backgroundColour = globals.defaultColours.white,
        })
    
        local selectTool = teverse.construct("guiIcon", {
            parent = toolsContainer,
            size = guiCoord(0, 20, 0, 20),
            position = guiCoord(0.25, 0, 0.1, 0),
            iconId = "location-arrow",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.white,
        })
    
        local moveTool = teverse.construct("guiIcon", {
            parent = toolsContainer,
            size = guiCoord(0, 20, 0, 20),
            position = guiCoord(0.25, 0, 0.32, 0),
            iconId = "arrows-alt-h",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.white,
        })
    
        local rotateTool = teverse.construct("guiIcon", {
            parent = toolsContainer,
            size = guiCoord(0, 20, 0, 20),
            position = guiCoord(0.25, 0, 0.54, 0),
            iconId = "sync",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.white,
        })

        local sizeTool = teverse.construct("guiIcon", {
            parent = toolsContainer,
            size = guiCoord(0, 20, 0, 20),
            position = guiCoord(0.25, 0, 0.76, 0),
            iconId = "fa:s-expand",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.white,
        })

        local moreToolsContainer = teverse.construct("guiFrame", {
            parent = teverse.interface,
            name = "moreToolsContainer",
            size = guiCoord(0.04, 0, 1, 0),
            position = guiCoord(0, 0, 0.255, 0),
            backgroundColour = globals.defaultColours.white,
        })

        self.registerPage = function(pageName)
            --[[
                @Description
                    Registers page to sidebar instance. 

                @Params
                    String, pageName

                @Returns
                   guiFrame, page
            ]]--

            local zIndexRange
            if pageName == "Default" then -- Default page zIndex is set lower than other pages
                zIndexRange = 100
            else
                zIndexRange = 101
            end

            local iconContainer = teverse.construct("guiFrame", {
                parent = moreToolsContainer,
                name = pageName,
                size = guiCoord(1, 0, 1, 0),
                position = guiCoord(0, 0, 0, 0),
                backgroundColour = globals.defaultColours.white,
                zIndex = zIndexRange,
                visible = false
            })
            return iconContainer
        end

        self.registerIcon = function(page, name, icon, tooltip, callback, ...)
            --[[
                @Description
                    Registers icon to page instance. 

                @Params
                    Instance, page
                    String, name
                    String, icon
                    String, tooltip
                    Method, callback
                    {...}, overrides 

                @Returns
                   Void, null, nil
            ]]--

            local args = {...} -- Holds overrides
            local xPositionOverride = args[1] or 0 -- Override if specified, else 0
            local positionToolTipOverride = args[2] or guiCoord(0, 0, 0, 0) -- Override if specified, else guiCoord(0, 0, 0, 0)
            local iconImage = teverse.construct("guiIcon", {
                parent = page,
                name = name,
                size = guiCoord(0, 20, 0, 20),
                position = guiCoord((0.25+xPositionOverride), 0, 0.02+(#page.children*0.04), 0), -- Shorthand positioning w/o a for-loop
                iconId = icon,
                iconType = "faSolid",
                iconColour = globals.defaultColours.primary,
                backgroundColour = globals.defaultColours.white,
            })

            local _tooltip = toolTip.construct("horizontal", iconImage, tooltip, positionToolTipOverride) -- Initialize tooltip instance

            --button:mouseLeftPressed(callback) -- When button is clicked, perform callback action

            -- When mouse hovers over button, display tooltip
            iconImage:on("mouseFocused", function() 
                _tooltip.display()
            end)

            -- When mouse leaves from button, hide tooltip
            iconImage:on("mouseUnfocused", function() 
                _tooltip.hide()
            end)
        end

        return data
    end
}