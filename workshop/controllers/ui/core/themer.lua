-- Copyright 2020 Teverse.com
-- Responsible for managing the aesthetics of different UI elements

local currentTheme = require("tevgit:workshop/controllers/ui/themes/default.lua")
local registeredGuis = {}

local function themeriseGui(gui)
    -- Grab the gui's style name set in the "registerGui" func
    local styleName = registeredGuis[gui]

    -- get the style's properties from the current theme
    local style = currentTheme[styleName]
    if not style then 
        style = {} 
    end

    -- apply the theme's properties to the gui
    for property, value in pairs(style) do
        if gui[property] and gui[property] ~= value then
            gui[property] = value
        end
    end
end

return {
    types = {
        primary             = "primary",
        primaryVariant      = "primaryVariant",
        primaryText         = "primaryText",
        
        secondary           = "secondary",
        secondaryVariant    = "secondaryVariant",
        secondaryText       = "secondaryText",
        
        error               = "error",
        errorText           = "errorText",
        
        background          = "background",
        backgroundText      = "backgroundText",        
    },
    
    themeriseGui = themeriseGui,

    registerGui = function(gui, style)
        -- set the gui's style and themerise it.
        registeredGuis[gui] = style
        themeriseGui(gui)
    end,
    
    setTheme = function(theme)
        -- change the current theme AND re-themerise all guis
    	currentTheme = theme
    	for gui,v in pairs(registeredGuis) do
    		themeriseGui(gui)
    	end
    end
    
}