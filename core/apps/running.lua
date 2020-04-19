-- This script is ran when the user is running a shared app

local appsContainer = teverse.construct("guiTextBox", {
    parent = teverse.coreInterface,
    size = guiCoord(1, 0, 0, 15),
    position = guiCoord(0, 0, 1, -15),
    backgroundAlpha = 0,
    text = "You are running user generated code",
    textShadowSize = 4,
    textSize = 12,
    textColour = colour(1, 1, 1),
    textAlign = "middle"
})