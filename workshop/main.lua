-- Copyright 2019 Teverse
-- This script is required when workshop is loaded, 
-- and engine.workshop is passed to the function returned.
-- e.g. require('tevgit:workshop/main.lua')(engine.workshop)

local shared = require("tevgit:workshop/controllers/shared.lua")

return function( workshop )
    shared.workshop = workshop
    
    -- Create the Teverse interface
    require("tevgit:workshop/controllers/ui/createInterface.lua")
end