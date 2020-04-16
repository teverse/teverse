local container = teverse.construct("guiFrame", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 300, 0, 500),
    position = guiCoord(0, 20, 0, 20),
    backgroundAlpha = 0.7,
    zIndex = 1000,
    strokeRadius = 2,
    visible = false
})

return container