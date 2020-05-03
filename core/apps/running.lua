-- This script is ran when the user is running a shared app

local disclaimer = teverse.construct("guiTextBox", {
    parent = teverse.coreInterface,
    size = guiCoord(1, -60, 0, 20),
    position = guiCoord(0, 30, 1, -20),
    backgroundAlpha = 0,
    text = "You are running user generated code",
    textShadowSize = 2,
    textSize = 12,
    textColour = colour(1, 1, 1),
    textAlign = "middle"
})

disclaimer:on("mouseLeftUp", function()
    teverse.apps:reload()
end)