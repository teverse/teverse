return {
    name = "Develop",
    iconId = "layer-group",
    iconType = "faSolid",
    setup = function(page)
        teverse.construct("guiTextBox", {
            parent = page,
            size = guiCoord(1.0, -20, 0, 48),
            position = guiCoord(0, 10, 0, 10),
            backgroundAlpha = 0,
            text = "Develop for Tablets is coming soon",
            textSize = 48,
            textAlign = "middleLeft"
        })
    end
}