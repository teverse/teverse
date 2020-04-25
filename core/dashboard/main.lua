local loadingText = teverse.construct("guiTextBox", {
    parent = teverse.interface,
    size = guiCoord(2, 0, 2, 0),
    position = guiCoord(-0.5, 0, -0.5, 0),
    backgroundColour = colour.black(),
    textColour = colour.white(),
    text = "teverse",
    textAlign = "middle",
    textSize = 38,
    textFont = "tevurl:fonts/moskUltraBold.ttf",
    zIndex = 2000
})

local ui = require("tevgit:core/dashboard/ui.lua")
ui.setup()

loadingText:destroy()