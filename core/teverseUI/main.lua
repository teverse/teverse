-- This is the main interface loaded into coreinterface

-- status bar for mobiles:
teverse.construct("guiFrame", {
    name = "statusBar",
    parent = teverse.coreInterface,
    size = guiCoord(1, 0, 0, 50),
    position = guiCoord(0, 0, 0, -50),
    backgroundColour = colour.black(),
    backgroundAlpha = 0.75
})

if teverse.dev.localTevGit then
    teverse.construct("guiTextBox", {
        parent = teverse.coreInterface,
        size = guiCoord(0,60, 0, 12),
        position = guiCoord(1, -70, 1, -59),
        zIndex = 1000,
        textSize = 12,
        text = "Local TevGit",
        textAlign = "middleRight",
        textAlpha = 0.5,
        backgroundAlpha = 0
    })
end

local settingsButton = teverse.construct("guiIcon", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 35, 0, 35),
    position = guiCoord(1, -45, 1, -45),
    iconId = "wrench",
    iconType = "faSolid",
    iconColour = colour(0, 0, 0),
    iconMax = 12,
    iconAlpha = 0.75,
    strokeRadius = 2,
    dropShadowAlpha = 0.15,
    strokeAlpha = 0.05,
    backgroundAlpha = 1,
    visible = teverse.networking.localClient ~= nil,
    zIndex = 1000
})

local container = teverse.construct("guiFrame", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 100, 0, 35),
    position = guiCoord(1, -155, 1, -45),
    backgroundAlpha = 0,
    visible = false
})

local console = require("tevgit:core/teverseUI/console.lua")
local lastClick = 0
settingsButton:on("mouseLeftUp", function()
    if os.clock() - lastClick < 0.4 then
        -- double click
        lastClick = 0
        console.visible = not console.visible
    else
        lastClick = os.clock()
        container.visible = true
        repeat sleep(0.1) until teverse.input.mousePosition.y < container.absolutePosition.y - 25
        container.visible = false
    end
end)

local homeButton = teverse.construct("guiIcon", {
    parent = container,
    size = guiCoord(0, 35, 0, 35),
    position = guiCoord(1, -35, 0, 0),
    iconId = "home",
    iconType = "faSolid",
    iconColour = colour(0, 0, 0),
    iconMax = 12,
    iconAlpha = 0.75,
    strokeRadius = 2,
    dropShadowAlpha = 0.15,
    strokeAlpha = 0.05,
    backgroundAlpha = 1
})

homeButton:on("mouseLeftUp", function()
    teverse.apps:loadDashboard()
end)