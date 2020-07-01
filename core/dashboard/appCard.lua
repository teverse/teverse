return function(app)
    local appGui = teverse.construct("guiFrame", {
        strokeRadius = 2,
        dropShadowAlpha = 0.15,
        strokeAlpha = 0.05
    })

    teverse.guiHelper.hoverColour(appGui, colour.rgb(247, 247, 247))

    teverse.construct("guiTextBox", {
        parent = appGui,
        size = guiCoord(1.0, -20, 0, 22),
        position = guiCoord(0, 10, 0, 5),
        backgroundAlpha = 0,
        text = app.name,
        textSize = 22,
        textAlign = "middleLeft",
        textFont = "tevurl:fonts/openSansBold.ttf",
        active = false
    })

    teverse.construct("guiTextBox", {
        parent = appGui,
        size = guiCoord(1.0, -20, 0, 16),
        position = guiCoord(0, 10, 0, 24),
        backgroundAlpha = 0,
        textAlpha = 0.5,
        text = "by " .. app.owner.username,
        textSize = 16,
        active = false
    })

    local img = teverse.construct("guiImage", {
        size = guiCoord(1, 0, 1, 0),
        parent = appGui,
        active = false, 
        zIndex = -1
    })

    local launch = teverse.construct("guiTextBox", {
        parent = appGui,
        size = guiCoord(0, 80, 0, 24),
        position = guiCoord(1, -90, 1, -34),
        backgroundColour = colour.rgb(61, 164, 54),
        text = "LAUNCH",
        textAlign = "middle",
        textColour = colour(1, 1, 1),
        textFont = "tevurl:fonts/openSansBold.ttf",
        textSize = 18,
        strokeRadius = 12,
        dropShadowAlpha = 0.1
    })

    launch:on("mouseEnter", function()
        launch.backgroundColour = colour.rgb(81, 184, 64)
        launch.dropShadowAlpha = 0.0
        launch:waitFor("mouseExit")
        launch.backgroundColour = colour.rgb(61, 164, 54)
        launch.dropShadowAlpha = 0.1
    end)

    if (app.iconUrl and app.iconUrl ~= "") then
        img.image = app.iconUrl
    else
        img.image = "tevurl:img/tevapp.png"
    end

    return appGui, launch
end