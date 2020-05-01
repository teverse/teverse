local containerNegativePadding = teverse.construct("guiFrame", {
    parent = teverse.interface,
    size = guiCoord(1, 0, 1, 100),
    position = guiCoord(0, 0, 0, -50)
})

local container = teverse.construct("guiScrollView", {
    parent = containerNegativePadding,
    size = guiCoord(1, 0, 1, -100),
    position = guiCoord(0, 0, 0, 50),
    backgroundAlpha = 0,
})

teverse.construct("guiTextBox", {
    parent = container,
    size = guiCoord(1.0, -20, 0, 48),
    position = guiCoord(0, 10, 0, 10),
    backgroundAlpha = 0,
    text = "Learn Code",
    textSize = 48,
    textAlign = "middleLeft"
})

local y = 70

for i,v in pairs(require("tevgit:core/tutorials/lessons.lua")) do
    local lesson = teverse.construct("guiFrame", {
        parent = container,
        position = guiCoord(0, 10, 0, y),
        size = guiCoord(1, -20, 0, 50),
        backgroundColour = colour.rgb(245, 245, 245),
        dropShadowAlpha = 0.2,
        strokeRadius = 3
    })

    teverse.construct("guiTextBox", {
        parent = lesson,
        size = guiCoord(0, 40, 1, -10),
        position = guiCoord(0, 5, 0, 5),
        backgroundAlpha = 0,
        text = string.format("%02d", i),
        textSize = 32,
        textAlign = "middle",
        textFont = "tevurl:fonts/firaCodeMedium.otf",
        textColour = colour.rgb(211, 54, 130)
    })

    teverse.construct("guiTextBox", {
        parent = lesson,
        size = guiCoord(1.0, -60, 0, 22),
        position = guiCoord(0, 50, 0, 5),
        backgroundAlpha = 0,
        text = v.name,
        textSize = 22,
        textAlign = "middleLeft",
        textFont = "tevurl:fonts/openSansBold.ttf"
    })

    local desc = teverse.construct("guiTextBox", {
        parent = lesson,
        size = guiCoord(1.0, -60, 1, -25),
        position = guiCoord(0, 50, 0, 25),
        backgroundAlpha = 0,
        text = v.description,
        textSize = 18,
        textAlign = "topLeft",
        textWrap = true
    })

    lesson.size = guiCoord(1, -20, 0, 29 + desc.textDimensions.y)

    y = y + 25 + desc.textDimensions.y
end