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
        local count = 0
        self = data
        self.id = idValue -- Unique Indentifier
        --self.pages = {} -- Where we store our pages for sidebar
        --self.activeTool = nil
        
        local toolsContainer = teverse.construct("guiFrame", {
            parent = teverse.interface,
            size = guiCoord(0, 50, 1, 0),
            position = guiCoord(0, 0, 0, 40),
            backgroundColour = globals.defaultColours.primary,
            strokeAlpha = 0.1,
            zIndex = 199
        })

        self.registerPage = function(pageName)
            --[[
                @Description
                    Registers page instance. 

                @Params
                    String, pageName

                @Returns
                   instance, page
            ]]--
            local _count = 0
            local metadata = {}
            self = metadata

            local container = teverse.construct("guiFrame", {
                parent = toolsContainer,
                name = pageName,
                size = guiCoord(1, 0, 0, 600),
                position = guiCoord(-1, 0, 0, 200),
                backgroundAlpha = 0,
                zIndex = 200
            })

            self.getContainer = function() return container end
            self.getParentContainer = function() return toolsContainer end

            self.registerIcon = function(name, icon, callback)
                local _icon = teverse.construct("guiIcon", {
                    parent = container,
                    name = name,
                    size = guiCoord(0, 32, 0, 32),
                    position = guiCoord(0, 9, 0, (_count*42)+9),
                    iconId = icon,
                    iconType = "faSolid",
                    backgroundColour = globals.defaultColours.white,
                    iconAlpha = 0.75,
                    iconMax = 16,
                    strokeRadius = 3
                })

                _icon:on("mouseEnter", function()
                    _icon.backgroundAlpha = 0.15
                end)
    
                _icon:on("mouseExit", function()
                    _icon.backgroundAlpha = 0
                end)
    
                _icon:on("mouseLeftUp", function()
                    _icon.dropShadowAlpha = 0.2
                end)

                _count = _count + 1
            end

            return metadata
        end

        self.registerDefaultIcon = function(icon, callback)
            local icon = teverse.construct("guiIcon", {
                parent = toolsContainer,
                size = guiCoord(0, 32, 0, 32),
                position = guiCoord(0, 9, 0, (count*42)+9),
                iconId = icon,
                iconType = "faSolid",
                backgroundColour = globals.defaultColours.white,
                iconAlpha = 0.75,
                iconMax = 16,
                strokeRadius = 3,
            })

            icon:on("mouseEnter", function()
                icon.backgroundAlpha = 0.15
            end)

            icon:on("mouseExit", function()
                icon.backgroundAlpha = 0
            end)

            icon:on("mouseLeftUp", function()
                icon.dropShadowAlpha = 0.2
            end)

            count = count + 1
        end

        return data
    end
}