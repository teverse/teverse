--[[
    Copyright 2019 Teverse
    @File paint.lua
    @Author(s) TheCakeChicken
--]]

TOOL_NAME = "Paint"
TOOL_ICON = "fa:s-paint-brush"
TOOL_DESCRIPTION = "Use this to paint your blocks."

local toolsController = require("tevgit:create/controllers/tool.lua")
local uiController = require("tevgit:create/controllers/ui.lua")

local currentColour = colour:fromRGB(255,0,0)

local configWindow = uiController.createWindow(uiController.workshop.interface, guiCoord(0, 66, 0, 183), guiCoord(0, 140, 0, 90), "Colour Picker")
local colourPreview = engine.construct("guiFrame", configWindow, {
    size = guiCoord(0, 20, 1, -32),
    position = guiCoord(1, -25, 0, 27),
    backgroundColour = currentColour
})

local redInput = uiController.create("guiTextBox", configWindow, {
    size = guiCoord(1, -60, 0, 16),
    position = guiCoord(0, 30, 0, -27),
    backgroundColour = currentColour
}, "main")

configWindow.visible = false

local function onToolActivated(toolId)
    configWindow.visible = true
end

local function onToolDeactviated(toolId)
    configWindow.visible = false
end

return toolsController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    hotKey = enums.key.number6,

    activated = onToolActivated,
    deactivated = onToolDeactviated

})
