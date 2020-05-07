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
--ui.setup()

spawn(function()
    while sleep() do
for x = 1, 50 do
    local gui = teverse.construct("guiFrame", {
        parent = teverse.interface,
        size = guiCoord(0, 4, 0, 100),
        position = guiCoord(0, x * 4, 0, 10),
        backgroundColour = colour.random()
    })
    for y = 1, 4 do
        teverse.construct("guiFrame", {
            parent = gui,
            size = guiCoord(0, 5, 0, 5),
            position = guiCoord(0, 0, 0, y*10),
            backgroundColour = colour.random()
        })
    end
end
sleep()
teverse.interface:destroyChildren()
end
end)

loadingText:destroy()