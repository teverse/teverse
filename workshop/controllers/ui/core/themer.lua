-- Copyright 2019 Teverse.com
-- Responsible for managing the aesthetics of different UI elements

local currentTheme = require('tevgit:workshop/controllers/ui/themes/default.lua')
local registeredGuis = {}

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
    
    themeriseGui = function(gui)
	    local styleName = registeredGuis[gui]
	
	    local style = currentTheme[styleName]
	    if not style then 
		    style = {} 
	    end

		for property, value in pairs(style) do
			if gui[property] and gui[property] ~= value then
				gui[property] = value
			end
		end
	end,
    
    registerGui = function(gui, style)
        registeredGuis[gui] = style
        themeriseGui(gui)
    end,
    
    setTheme = function(theme)
    	currentTheme = theme
    	for gui,v in pairs(registeredGuis) do
    		themeriseGui(gui)
    	end
    end
    
}