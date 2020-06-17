-- Copyright 2020- Teverse
-- This script constructs (or builds) the topbar controller

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files
local toolTip = require("tevgit:workshop/library/ui/components/toolTip.lua") -- UI component

return {
    construct = function(idValue, nameValue)
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
        local count = 0
        local _count = 0
        local clicked = false
        local pushed = false
        self = data -- Ease of use
        self.id = idValue -- Unique indentifier
        self.name = nameValue -- Name of scene being edited / developed on
        self.keys = {} -- Where item keys are stored
        self.pages = {}
        self.defaultPage = nil
        self.currentPage = nil

        local container = teverse.construct("guiFrame", {
            parent = teverse.interface,
            name = idValue,
            size = guiCoord(1, 0, 0, 40),
            position = guiCoord(0, 0, 0, 0),
            backgroundColour = globals.defaultColours.white,
            dropShadowAlpha = 0.4,
            dropShadowBlur = 2,
            dropShadowColour = colour.rgb(127, 127, 127),
            dropShadowOffset = vector2(0.5, 1),
            zIndex = 200
        })

        local subContainer = teverse.construct("guiFrame", {
            parent = container,
            size = guiCoord(0, 140, 0.8, 0),
            position = guiCoord(0, 8, 0, 4),
            backgroundColour = globals.defaultColours.primary,
            backgroundAlpha = 0.15,
            strokeRadius = 3,
            zIndex = 900
        })

        local menuContainer = teverse.construct("guiFrame", {
            parent = container,
            size = guiCoord(0, 140, 0.01, 0),
            position = guiCoord(0, 8, 0, 35),
            backgroundColour = globals.defaultColours.primary,
            backgroundAlpha = 0,
            strokeWidth = 1,
            zIndex = 900
        })

        self.animate = function(page, pos)
            teverse.tween:begin(page, 0.5, { position = pos }, "inOutQuad")
        end

        local headerIcon = teverse.construct("guiIcon", {
            parent = subContainer,
            size = guiCoord(0, 32, 0, 32),
            position = guiCoord(0, 0, 0, 0),
            iconId = "cloud",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.primary,
            backgroundAlpha = 0.1,
            iconAlpha = 0.75,
            iconMax = 16,
            strokeRadius = 3,
        })

        local function buildTabMenu()
            local itemCount = 0
            if (#data.pages == 0) then return end
            for _,v in pairs(data.pages) do
                for key, value in pairs(v) do
                    
                    -- Key = (String) name of label
                    -- Value = (Object(guiFrame)) instance page
                    local _itemContainer = teverse.construct("guiFrame", {
                        parent = menuContainer,
                        size = guiCoord(1, 0, 0.3, 0),
                        position = guiCoord(0, 0, 0, (itemCount*21)+0),
                        backgroundColour = globals.defaultColours.red,
                        backgroundAlpha = 0,
                        zIndex = 200
                    })

                    local _itemButton = teverse.construct("guiTextBox", {
                        parent = _itemContainer,
                        size = guiCoord(0.97, 0, 1, 0),
                        position = guiCoord(0.03, 0, 0, 0),
                        text = key,
                        textAlign = "middle",
                        textSize = 20,
                        textFont = "tevurl:fonts/openSansBold.ttf",
                        textColour = globals.defaultColours.white,
                        backgroundColour = globals.defaultColours.primary,
                        backgroundAlpha = 1,
                        zIndex = 200
                    })

                    local _itemContainerShader = teverse.construct("guiFrame", {
                        parent = _itemContainer,
                        size = guiCoord(0.03, 0, 1, 0),
                        position = guiCoord(0, 0, 0, 0),
                        backgroundColour = globals.defaultColours.white,
                        backgroundAlpha = 0
                    })

                    _itemButton:on("mouseEnter", function()
                        _itemContainerShader.backgroundAlpha = 0.15
                    end)
        
                    _itemButton:on("mouseExit", function()
                        _itemContainerShader.backgroundAlpha = 0
                    end)

                    _itemButton:on("mouseLeftUp", function()
                        print("Clicked")
                        --[[data.animate(data.currentPage, guiCoord(-1, 0, 0, 200))
                        sleep(0.5)
                        data.animate(value, guiCoord(1, 0, 0, 200))
                        data.currentPage = page]]--
                    end)

                    itemCount = itemCount + 1
                end
            end
        end

        headerIcon:on("mouseLeftUp", function()
            if (clicked) then
                menuContainer.backgroundAlpha = 1
                menuContainer.strokeAlpha = 0.15
                teverse.tween:begin(menuContainer, 0.5, { size = guiCoord(0, 140, 2.2, 0) }, "inOutQuad", buildTabMenu())
            end

            if (not clicked) then
                teverse.tween:begin(menuContainer, 0.5, { size = guiCoord(0, 140, 0.01, 0) }, "inOutQuad", menuContainer:destroyChildren())
                sleep(0.5)
                menuContainer.strokeAlpha = 0
                menuContainer.backgroundAlpha = 0
            end

            clicked = (not clicked)
        end)
        
        local headerText = teverse.construct("guiTextBox", {
            parent = subContainer,
            size = guiCoord(1, 0, 0, 32),
            position = guiCoord(0, 40, 0, 0),
            text = " "..nameValue,
            textAlign = "middleLeft",
            textSize = 20,
            textFont = "tevurl:fonts/openSansBold.ttf",
            textColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.primary,
            backgroundAlpha = 0,
            strokeRadius = 3
        })

        self.registerIcon = function(icon, callback)
            local icon = teverse.construct("guiIcon", {
                parent = container,
                size = guiCoord(0, 32, 0, 32),
                position = guiCoord(1, (count*-37)-37, 0, 4),
                iconId = icon,
                iconType = "faSolid",
                iconColour = globals.defaultColours.primary,
                backgroundColour = globals.defaultColours.primary,
                iconAlpha = 0.75,
                iconMax = 16,
                strokeRadius = 3,
                zIndex = 900
            })

            icon:on("mouseEnter", function()
                icon.backgroundAlpha = 0.15
            end)

            icon:on("mouseExit", function()
                icon.backgroundAlpha = 0
            end)

            icon:on("mouseLeftUp", function()
                icon.iconAlpha = 1.0
                icon.dropShadowAlpha = 0.2
            end)

            count = count + 1
        end

        self.bindDefaultMenu = function(page)
            self.defaultPage = page
            self.currentPage = page
            data.animate(page, guiCoord(0, 0, 0, 200))
        end

        self.bindMenu = function(name, page)
            table.insert(data.pages, #data.pages+1, { [name] = page })
            _count = _count + 1
        end

        --self.defaultPage = nil
        --self.currentPage = nil
        
        return data
    end
}