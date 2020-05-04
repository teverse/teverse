-- Copyright 2020- Teverse
-- This script constructs (or builds) the topbar controller

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files
local toolTip = require("tevgit:workshop/library/ui/components/toolTip.lua") -- UI component

return {
    construct = function(idValue, titleIconValue, titleValue)
        --[[
            @Description
                Constructor method that initializes the topbar instance.

            @Params
                String, idValue
                String, titleIconValue
                String, titleValue
            
            @Returns
                Instance, topbar
        ]]--

        local data = {} 
        self = data -- Ease of use
        self.id = idValue
        self.title = titleValue
        self.titleIcon = titleIconValue
        self.keys = {} -- Where item keys are stored

        local container = teverse.construct("guiFrame", {
            parent = teverse.interface,
            size = guiCoord(1, 0, 0, 40),
            position = guiCoord(0, 0, 0, 0),
            backgroundColour = globals.defaultColours.white,
        })

        teverse.construct("guiImage", {
            parent = container,
            size = guiCoord(0, 28, 0, 28),
            position = guiCoord(0.01, 0, 0.1, 0),
            iconId = titleIconValue,
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.white,
            active = false,
        })

        teverse.construct("guiTextBox", {
            parent = container,
            size = guiCoord(0.5, 0, 0.1, 0),
            position = guiCoord(0.04, 0, 0.05, 0),
            text = titleValue,
            textColour = globals.defaultColours.primary,
            textFont = "tevurl:fonts/openSansBold.ttf",
            textSize = 30
        })

        teverse.construct("guiTextBox", {
            parent = container,
            size = guiCoord(0.48, 0, 0.1, 0),
            position = guiCoord(0.86, 0, 0.1, 0),
            text = globals.user.name,
            textColour = globals.defaultColours.primary,
            textSize = 25
        })

        local userIcon = teverse.construct("guiFrame", {
            parent = container,
            size = guiCoord(0, 32, 0, 32),
            position = guiCoord(0.82, 0, 0, 0),
            backgroundColour = globals.defaultColours.primary,
            strokeRadius = 100
        })

        local statusIcon = teverse.construct("guiFrame", {
            parent = container
            size = guiCoord(0, 16, 0, 16),
            position = guiCoord(0.836, 0, 0.5, 0),
            backgroundColour = globals.defaultColours.green,
            strokeWidth = 2,
            strokeColour = globals.defaultColours.white,
            strokeAlpha = 1,
            strokeRadius = 32,
            zIndex = 100
        })

        local undoButton = teverse.construct("guiImage", {
            parent = container,
            size = guiCoord(0, 20, 0, 20),
            position = guiCoord(0.92, 0, 0.2, 0),
            iconId = "arrow-left",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.white,
        })

        local redoButton = teverse.construct("guiImage", {
            parent = container,
            size = guiCoord(0, 20, 0, 20),
            position = guiCoord(0.94, 0, 0.2, 0),
            iconId = "arrow-right",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.white,
        })

        local settingsButton = teverse.construct("guiImage", {
            parent = container,
            size = guiCoord(0, 20, 0, 20),
            position = guiCoord(0.97, 0, 0.2, 0),
            iconId = "sliders-h",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.white,
        })
        local test = self
        self.register = function(name, tooltip, page)
            --[[
                @Description
                    Register method that appends to the topbar instance.

                @Params
                    String, name
                    String, tooltip
                    Instance, page
                
                @Returns
                    Void, null, nil
            ]]--

            table.insert(test.keys, {name})
            local button = teverse.construct("guiTextBox", {
                parent = container,
                size = guiCoord(0.056, 0, 0.9, 0),
                position = guiCoord(0.2+(#test.keys*0.07), 0, 0.05, 0),
                text = name,
                textColour = globals.defaultColours.primary,
                textSize = 22,
                textAlign = enums.align.middle,
                zIndex = 100
            })

            local _tooltip = toolTip.construct("vertical", button, tooltip) -- Initialize tooltip instance

            button:on("mouseLeftDown", function()
                globals.sideBarPageActive.visible = (not globals.sideBarPageActive.visible) -- Unlist active page from view
                if globals.sideBarPageActive == page then -- If the same page is clicked twice, unlist and replace with default page
                    globals.sideBarPageActive = globals.sideBarPageDefault
                    globals.sideBarPageDefault.visible = true
                    return -- Acts as a break
                end
                globals.sideBarPageActive = page
                page.visible = (not page.visible)
            end)

            -- When mouse hovers over button, display tooltip
            button:on("mouseEnter", function() 
                _tooltip.display()
            end)

            -- When mouse leaves from button, hide tooltip
            button:on("mouseExit", function() 
                _tooltip.hide()
            end)
        end
        return data
    end
}