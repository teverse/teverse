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
local selectionController  = require("tevgit:create/controllers/select.lua")

local toolActive = false
local currentColour = colour:fromRGB(255,255,255)

local configWindow = uiController.createWindow(uiController.workshop.interface, guiCoord(0, 66, 0, 183), guiCoord(0, 140, 0, 90), "Colour Picker")

local colourDisplay = engine.construct("guiFrame", configWindow.content, {
    name = "colourPreview",
    position = guiCoord(1, -25, 0, 5),
    size = guiCoord(0, 20, 1, -10),
    backgroundColour = currentColour
})

local redLabel = uiController.create("guiTextBox", configWindow.content, {
    size = guiCoord(0, 20, 0, 16),
    position = guiCoord(0, 5, 0, 5),
    multiline = false,
    fontSize = 16,
    text = "R",
    align = enums.align.middle
}, "mainTopBar")

local greenLabel = uiController.create("guiTextBox", configWindow.content, {
    size = guiCoord(0, 20, 0, 16),
    position = guiCoord(0, 5, 0, 26),
    multiline = false,
    fontSize = 16,
    text = "G",
    align = enums.align.middle
}, "mainTopBar")

local blueLabel = uiController.create("guiTextBox", configWindow.content, {
    size = guiCoord(0, 20, 0, 16),
    position = guiCoord(0, 5, 0, 47),
    multiline = false,
    fontSize = 16,
    text = "B",
    align = enums.align.middle
}, "mainTopBar")

local redInput = uiController.create("guiTextBox", configWindow.content, {
    size = guiCoord(1, -60, 0, 16),
    position = guiCoord(0, 30, 0, 5),
    readOnly = false,
    multiline = false,
    fontSize = 18,
    text = "255",
    align = enums.align.middle,
    name = "redInput"
}, "main")

local greenInput = uiController.create("guiTextBox", configWindow.content, {
    size = guiCoord(1, -60, 0, 16),
    position = guiCoord(0, 30, 0, 26),
    readOnly = false,
    multiline = false,
    fontSize = 18,
    text = "255",
    align = enums.align.middle,
    name = "greenInput"
}, "main")

local blueInput = uiController.create("guiTextBox", configWindow.content, {
    size = guiCoord(1, -60, 0, 16),
    position = guiCoord(0, 30, 0, 47),
    readOnly = false,
    multiline = false,
    fontSize = 18,
    text = "255",
    align = enums.align.middle,
    name = "blueInput"
}, "main")

configWindow.visible = false

local function updateColour()
    currentColour = colour:fromRGB(tonumber(redInput.text), tonumber(greenInput.text), tonumber(blueInput.text))
    colourDisplay.backgroundColour = currentColour
end

redInput:textInput(updateColour)
greenInput:textInput(updateColour)
blueInput:textInput(updateColour)

local function paintAllSelected()
    if not toolActive then return end
    for _,object in next,selectionController.selection do
        object.colour = currentColour
    end
end

local function onToolActivated(toolId)
    configWindow.visible = true
    toolActive = true

    if selectionController.selection[1] then
        local obj = selectionController.selection[1]
        local r = obj.colour.r * 255
        local g = obj.colour.g * 255
        local b = obj.colour.b * 255

        redInput.text = tostring(r)
        greenInput.text = tostring(g)
        blueInput.text = tostring(b)
        updateColour()
    end

    selectionController.boundingBox:changed(paintAllSelected)
    paintAllSelected()
end

local function onToolDeactivated(toolId)
    configWindow.visible = false
    toolActive = false
end

return toolsController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    hotKey = enums.key.number5,

    activated = onToolActivated,
    deactivated = onToolDeactivated

})
