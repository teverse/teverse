return {
    name = "Apps",
    iconId = "shapes",
    iconType = "faSolid",
    setup = function(page)
        teverse.construct("guiTextBox", {
            parent = page,
            size = guiCoord(1.0, -20, 0, 48),
            position = guiCoord(0, 10, 0, 10),
            backgroundAlpha = 0,
            text = "Apps",
            textSize = 48,
            textAlign = "middleLeft"
        })
        teverse.construct("guiTextBox", {
            parent = page,
            size = guiCoord(1.0, -20, 0, 18),
            position = guiCoord(0, 10, 0, 58),
            backgroundAlpha = 0,
            text = "Coming soon in a minor update!",
            textSize = 18,
            textAlign = "middleLeft"
        })
    end
}