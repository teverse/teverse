-- This script is ran when the user is running a shared app

local disclaimer = teverse.construct("guiTextBox", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 140, 0, 25),
    position = guiCoord(0.5, -70, 1, -35),
    text = "User Generated Content",
    textSize = 14,
    textColour = colour(0, 0, 0),
    textAlign = "middle",
    textFont = "tevurl:fonts/openSansSemiBold.ttf",
    strokeRadius = 2,
    dropShadowAlpha = 0.15,
    strokeAlpha = 0.05
})

disclaimer:on("mouseLeftUp", function()
    teverse.apps:reload()
end)