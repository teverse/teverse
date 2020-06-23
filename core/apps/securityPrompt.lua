return function(blacklisted, cancel, allow)
    -- this function is ran when a untrusted .tevapp is about to run
    -- invoke cancel to return teverse to a safe state
    -- invoke allow to run the untrusted code

    local backdrop = teverse.construct("guiFrame", {
        parent = teverse.coreInterface,
        size = guiCoord(1, 0, 1, 0),
        position = guiCoord(0, 0, 0, 0),
        zIndex = 2000,
        backgroundColour = colour.rgb(181, 83, 76),
        backgroundAlpha = 0.85
    })

    local container = teverse.construct("guiFrame", {
        parent = backdrop,
        size = guiCoord(0, 280, 0, 100),
        position = guiCoord(0.5, -140, 0.5, -50),
        backgroundColour = colour(0.95, 0.95, 0.95),
        dropShadowAlpha = 0.3,
        strokeRadius = 3,
        strokeAlpha = 0.1
    })

    local label = teverse.construct("guiTextBox", {
        parent = container,
        size = guiCoord(1, -20, 1, -50),
        position = guiCoord(0, 10, 0, 10),
        backgroundAlpha = 0,
        textWrap = true,
        text = "We blocked an app from an unidentified developer, are you sure you'd like to continue?",
        textAlign = "middle"
    })

    if not blacklisted then
        local allowBtn = teverse.construct("guiTextBox", {
            parent = container,
            size = guiCoord(0.5, -5, 0, 30),
            position = guiCoord(0, 0, 1, -30),
            backgroundAlpha = 0,
            text = "ALLOW",
            textFont = "tevurl:fonts/openSansBold.ttf",
            textAlign = "middle"
        })

        allowBtn:on("mouseLeftUp", allow)
    end

    local cancelBtn = teverse.construct("guiTextBox", {
        parent = container,
        size = guiCoord(0.5, -5, 0, 30),
        position = guiCoord(0.5, 5, 1, -30),
        backgroundColour = colour.rgb(74, 140, 122),
        textColour = colour.white(),
        text = "BLOCK",
        textFont = "tevurl:fonts/openSansBold.ttf",
        textAlign = "middle"
    })

    cancelBtn:on("mouseLeftUp", cancel)

    if blacklisted then
        cancelBtn.position = guiCoord(0, 0, 1, -30)
        cancelBtn.size = guiCoord(1, 0, 0, 30)
        cancelBtn.text = "OK"
        label.text = "This app was blocked; please speak to Teverse for more details."
    end
    --allow()
end