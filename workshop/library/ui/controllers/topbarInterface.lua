-- Copyright 2020- Teverse
-- This script constructs (or builds) the topbar controller

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files
local toolTip = require("tevgit:workshop/library/ui/components/toolTip.lua") -- UI component
local commands = require("tevgit:workshop/library/toolchain/commands.lua") -- Commandbar toolchain component

-- Core Command Groups
local show_commandGroup = commands.createGroup("Show")


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
        local defaultPage = nil
        local currentPage = nil

        self.animate = function(page, pos)
            teverse.tween:begin(page, 0.5, { position = pos }, "inOutQuad")
        end

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
            size = guiCoord(0, 140, 2.2, 0),
            position = guiCoord(0, 8, 0, 35),
            backgroundColour = globals.defaultColours.primary,
            backgroundAlpha = 0,
            strokeWidth = 1,
            zIndex = 900
        })

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

        headerIcon:on("mouseLeftUp", function()
            if (clicked) then
                -- idk
            else
                -- idk
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

        -- Test command Bar
        local commandBarIcon = teverse.construct("guiIcon", {
            parent = container,
            size = guiCoord(0, 32, 0, 32),
            position = guiCoord(0, 160, 0, 4),
            iconId = "search",
            iconType = "faSolid",
            iconColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.primary,
            backgroundAlpha = 0.1,
            iconAlpha = 0.75,
            iconMax = 16,
            strokeRadius = 3,
        })

        local commandBarField = teverse.construct("guiTextBox", {
            parent = container,
            size = guiCoord(0, 200, 0, 32),
            position = guiCoord(0, 191, 0, 4),
            --text = "  >",
            textAlign = "middleLeft",
            textFont = "tevurl:fonts/firaCodeBold.otf",
            textSize = 15,
            textColour = globals.defaultColours.primary,
            backgroundColour = globals.defaultColours.primary,
            backgroundAlpha = 0.1,
            strokeRadius = 3,
            textEditable = true,
            textMultiline = false,
            visible = false
        })

        commandBarIcon:on("mouseLeftDown", function()
            if (clicked) then
                commandBarIcon.iconColour = globals.defaultColours.white
                commandBarIcon.backgroundAlpha = 1
                commandBarField.text = "  >"
                commandBarField.visible = true
            else
                commandBarIcon.iconColour = globals.defaultColours.primary
                commandBarIcon.backgroundAlpha = 0.1
                commandBarField.visible = false
            end
            clicked = (not clicked)
        end)

        commandBarField:on("keyDown", function(key)
            if key == "KEY_RETURN" then
                print("Command: "..(commandBarField.text))

                -- Invoke Command Trigger
                commands.parse(commandBarField.text)
                
                commandBarField.text = "  >"
            end
        end)


        -- End Test Command Bar

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
                callback()
            end)

            count = count + 1
        end

        self.bindDefaultMenu = function(page)
            defaultPage = page
            currentPage = page
            data.animate(page, guiCoord(0, 0, 0, 200))
        end

        self.bindMenu = function(name, page)
            table.insert(data.pages, #data.pages+1, { [name] = page })
            show_commandGroup.command(name, function()
                if currentPage.id == page.id then
                    data.animate(currentPage, guiCoord(-1, 0, 0, 200)) 
                    data.animate(defaultPage, guiCoord(0, 0, 0, 200))
                    currentPage = defaultPage
                    return
                end
                
                data.animate(currentPage, guiCoord(-1, 0, 0, 200)) 
                data.animate(page, guiCoord(0, 0, 0, 200))
                currentPage = page
            end)
            _count = _count + 1
        end

        return data
    end
}