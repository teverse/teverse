-- Copyright 2019 Teverse.com
-- This script includes shorcuts for creating UIs.
-- Any interface created here will be properly themed.

local themer = require('tevgit:workshop/ui/themer.lua')

return {
    create = function(className, parent, properties, style)
        if not parent then 
            parent = uiController.workshop.interface 
        end
        
        local gui = engine.construct(className, parent, properties)
        themer.registerGui(gui, style and style or "default")
        return gui
    end,
    
}