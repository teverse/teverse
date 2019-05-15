-- Copyright (c) 2019 teverse.com
-- console.lua

local consoleController = {}
local themeController = require("tevgit:create/controllers/theme.lua")
local uiController = require("tevgit:create/controllers/ui.lua")

consoleController.outputLines = {}
consoleController.outputCount = 0;

local windowObject = uiController.create("guiFrame", engine.workshop.interface, {
    name = "outputConsole";
    visible = false;
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
    uiController.create("guiTextBox", scrollView, {
        text = msg;
        size = guiCoord(1, -4, 0, 25);
        readOnly = true;
        position = guiCoord(0, 2, 0, consoleController.outputCount*25);
        name = "outputText";
        fontSize = 20;
    }, "default")

    consoleController.outputCount = consoleController.outputCount + 1

    local yCanvas = consoleController.outputCount * 25
    scrollView.canvasSize = guiCoord(1, 0, 0, yCanvas)
end)

if engine.debug.error then --error event may not exist, future update.
    engine.debug:error(function(errorInfo)
        --if errorInfo.action ~= "disconnection" then
            local errorWarning = uiController.create("guiTextBox", engine.workshop.interface, {
                text = "Error Captured (CLICK TO CLOSE)\n - - - - - - \nThread: " .. errorInfo.threadName .. " [" .. errorInfo.thread .. "]\nMessage: ".. errorInfo.message.."\nTraceback:\n"..errorInfo.traceback;
                align = enums.align.topLeft;
                size = guiCoord(0, 600, 0, 200);
                readOnly = true;
                position = guiCoord(1, 0, 1, -220);
                name = "errorMessage";
                fontSize = 14;
                guiStyle = enums.guiStyle.rounded;
            }, "secondary")

            engine.tween:begin(errorWarning, .5, {position=guiCoord(1,-610,1,-220)}, "inOutQuad")

            errorWarning:mouseLeftPressed(function ()
                errorWarning:destroy()
            end)
        --end
    end)
end

return consoleController