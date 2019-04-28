-- Copyright 2019 teverse.com

local uiController = {}
local themeController = require("tevcore:create/controllers/theme.lua")

uiController.createFrame = function(parent, properties)
    local gui = engine.construct("guiFrame", parent, properties)
		themeController.addGUI(gui, "primary")
		return gui
end

uiController.createMainInterface = function()

end

return uiController
