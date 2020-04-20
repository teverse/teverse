-- Copyright 2020- Teverse
-- This script is required when workshop is loaded.

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files

local function init(dev)
    --[[
        @Description
            The initializer method that comes first when a new scene is open. 

        @Params
            Instance, workshop
        
        @Returns
            void, null, nil
    ]]--

    globals.dev = dev -- Set teverse.dev (previously workshop) instance as a global
    globals.user = teverse:isAuthenticated() -- Set & Streamline user instance as a global
    globals.developerMode = (not globals.dev.hasLocalTevGit) or (globals.dev:hasLocalTevGit()) -- Set developmode boolean as a global

    local loadingScreen = teverse.construct("guiFrame", dev.interface, {
        size = guiCoord(1, 0, 1, 0),
        backgroundColour = globals.defaultColours.background,
        zIndex = 1000
    })

    teverse.construct("guiTextBox", loadingScreen, {
        size = guiCoord(0.5, 0, 0.5, 0),
        position = guiCoord(0.25, 0, 0.25, 0),
        align = enums.align.middle,
        backgroundAlpha = 0,
        text = "Downloading the latest workshop...\nThis takes longer than a moment during beta."
    })

    -- Load stuff before initial load in
    require("tevgit:workshop/library/ui/controllers/workshopInterface.lua")

    -- Loading is no longer needed by this phase, remove if still valid
    if loadingScreen then
    	loadingScreen:destroy()
    end
end

return function(dev)
    --[[
        @Description
            The main method that comes when a new scene is opened. 

        @Params
            Instance, workshop
        
        @Returns
            function, method
    ]]--
    
    local success, message = pcall(init, dev)
    local teverse = dev -- Laziness

    -- If initialize phase fails, prompt to the error screen
    if (not success) then
        teverse.interface:destroyAllChildren()

        local errorScreen = teverse.construct("guiFrame", teverse.interface, {
            size = guiCoord(1, 0, 1, 0),
            backgroundColour = globals.defaultColours.background,
            zIndex = 10000
        })

        teverse.construct("guiTextBox", errorScreen, {
            size = guiCoord(0.8, 0, 0.8, 0),
            position = guiCoord(0.1, 0, 0.1, 0),
            backgroundColour = globals.defaultColours.background,
            textColour = globals.defaultColours.red,
            align = enums.align.topLeft,
            text = "Error loading Workshop\nIf this isn't your fault, please take a screenshot and report this as a bug. \n\n" .. message .." \n\nPlease press 'ENTER' on your keyboard to restart Teverse.",
            wrap = true,
        })

        -- Bind the "return" key on the keyboard as temporary fast-reload keybind
        teverse.input:on("keyPressed", function(keyboard)
            if keyboard.key == enums.key["return"] then
                teverse:reloadCreate()
            end
        end)
    end

    -- Bind the "f12" key on the keyboard as fast-reload keybind if initialize phase is successful
    teverse.input:on("keyPressed", function(keyboard)
        if keyboard.key == enums.key["f12"] then
            teverse:reloadCreate()
        end
    end)
end