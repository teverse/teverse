-- This is the main interface loaded into coreinterface
local console = require("tevgit:core/teverseUI/console.lua")

local container = teverse.construct("guiFrame", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 77, 0, 26),
    position = guiCoord(1, -81, 1, -30),
    backgroundAlpha = 0.0,
    strokeRadius = 13,
    zIndex = 1000
})

local homebtn

local ico = teverse.construct("guiIcon", {
    parent = container,
    size = guiCoord(0, 20, 0, 20),
    position = guiCoord(1, -23, 0.5, -10),
    iconId = "wrench",
    iconType = "faSolid",
    iconColour = colour(0, 0, 0),
    iconMax = 12,
    iconAlpha = 0.75,
    strokeRadius = 10,
    strokeAlpha = 0.5,
    backgroundAlpha = 1,
    visible = teverse.networking.localClient ~= nil
})

local lastClick = 0
ico:on("mouseLeftDown", function()
    if os.clock() - lastClick < 0.4 then
        -- double click
        lastClick = 0
        console.visible = not console.visible
    else
        lastClick = os.clock()
    end
end)

--if teverse.dev.localTevGit then

homebtn = teverse.construct("guiTextBox", {
    parent = container,
    size = guiCoord(0, 40, 0, 14),
    position = guiCoord(0, 6, 0.5, -7),
    text = "HOME",
    textAlign = "middle",
    textFont = "tevurl:fonts/openSansLight.ttf",
    textColour = colour(0, 0, 0),
    textSize = 14,
    strokeRadius = 7,
    strokeAlpha = 0.5,
    backgroundAlpha = 0,
    visible = false
})

homebtn:on("mouseLeftUp", function()
    teverse.apps:loadDashboard()
end)

ico:on("mouseLeftUp", function()
    container.backgroundAlpha = 1.0
    homebtn.visible = true

    if teverse.dev.state == "dashboard" then
        if teverse.dev.localTevGit then
            homebtn.text = "RESET"
            homebtn.visible = true
        else
            homebtn.visible = false
        end
    else
        homebtn.text = "HOME"
        homebtn.visible = true
    end

    repeat sleep(0.1) until teverse.input.mousePosition.y < container.absolutePosition.y - 25

    container.backgroundAlpha = 0.0
    homebtn.visible = false
end)