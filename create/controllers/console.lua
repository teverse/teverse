-- Copyright (c) 2019 teverse.com
-- console.lua

local consoleController = {}
local themeController = require("tevgit:create/controllers/theme.lua")
local uiController = require("tevgit:create/controllers/ui.lua")

consoleController.outputLines = {"test1", "test2", "test3", "test4", "test5"}

local windowObject = uiController.create("guiFrame", engine.workshop.interface, {
    name = "outputConsole";
    visible = true;
    size = guiCoord(0.5, 0, 0.5, 0);
    position = guiCoord(0.25, 0, 0.25, 0);
})

consoleController.consoleObject = windowObject

local topbar = uiController.create("guiFrame", windowObject, {
    size = guiCoord(1, 0, 0, 25);
    name = "topbar";
}, "primary")

local titleText = uiController.create("guiTextBox", topbar, {
    size = guiCoord(0.2, 0, 1, -10);
    position = guiCoord(0, 10, 0, 5);
    text = "Console";
    fontSize = 20;
    readOnly = true;
    name = "windowTitle";
}, "primary")

local closeButton = uiController.create("guiTextBox", topbar, {
    backgroundColour  = colour:fromRGB(255, 0, 0);
    text = "X";
    size = guiCoord(0, 25, 0, 25);
    align = enums.align.middle;
    position = guiCoord(1, -25, 0, 0);
    name = "closeButton";
    readOnly = true;
}, "primary")

local scrollView = uiController.create("guiScrollView", windowObject, {
    size = guiCoord(1, 0, 1, -25);
    position = guiCoord(0, 0, 0, 25);
    canvasSize = guiCoord(1, 0, 0, 0);
})

consoleController.updateConsole = function()
    for Count,Output in pairs(consoleController.outputLines) do
        uiController.create("guiTextBox", scrollView, {
            text = msg;
            size = guiCoord(1, -10, 0, 25);
            readOnly = true;
            position = guiCoord(0, 5, 0, Count*25);
            name = "outputText";
            fontSize = 15;
        })
    end

    scrollView.canvasSize = guiCoord(1, 0, 0, #consoleController.outputLines * 25)
end

closeButton:mouseLeftPressed(function() 
    consoleController.consoleObject.visible = false
end)

engine.input:keyPressed(function( inputObj )
    if inputObj.systemHandled then return end

    if inputObj.key == enums.key.f12 then
        consoleController.consoleObject.visible = not consoleController.consoleObject.visible
    end
end)

engine.debug:output(function(msg)
    table.insert(consoleController.outputLines, msg)

    consoleController.updateConsole()
end)

return consoleController