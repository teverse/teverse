-- This script is ran when the user is running a local app/sandbox

local share = teverse.construct("guiTextBox", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 60, 0, 16),
    position = guiCoord(0.5, -65, 1, -16),
    strokeRadius = 2,
    text = "Share",
    textAlign = "middle",
    textSize = 12
})

local reload = teverse.construct("guiTextBox", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 60, 0, 16),
    position = guiCoord(0.5, 5, 1, -16),
    strokeRadius = 2,
    text = "Reload",
    textAlign = "middle",
    textSize = 12
})

local test = teverse.construct("guiTextBox", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 90, 0, 16),
    position = guiCoord(1.0, -140, 1, -16),
    strokeRadius = 2,
    text = "Remote Test",
    textAlign = "middle",
    textSize = 12
})

reload:on("mouseLeftUp", function()
    teverse.apps:reload()
end)

share:on("mouseLeftUp", function()
    share.visible = false
    reload.visible = false

    local backdrop = teverse.construct("guiFrame", {
        parent = teverse.coreInterface,
        size = guiCoord(1, 0, 1, 0),
        position = guiCoord(0, 0, 0, 0),
        backgroundColour = colour(.25, .25, .25),
        backgroundAlpha = 0.6,
        zIndex = 1000
    })

    local spinner = teverse.construct("guiIcon", {
        parent = backdrop,
        size = guiCoord(0, 40, 0, 40),
        position = guiCoord(0.5, -20, 0.5, -20),
        iconMax = 40,
        iconColour = colour(1, 1, 1),
        iconType = "faSolid",
        iconId = "spinner",
        iconAlpha = 0.9
    })

    spawn(function()
        while sleep() and spinner.alive do 
            spinner.rotation = spinner.rotation + math.rad(1)
        end
    end)

    teverse.apps:upload()
    local success, result = teverse.apps:waitFor("upload")
    spinner:destroy()

    local container = teverse.construct("guiTextBox", {
        parent = backdrop,
        size = guiCoord(0, 460, 0, 120),
        position = guiCoord(0.5, -230, 0.5, -60),
        backgroundColour = colour(1, 1, 1),
        dropShadowAlpha = 0.3,
    })

    local label = teverse.construct("guiTextBox", {
        parent = container,
        size = guiCoord(1.0, -20, 1.0, -20),
        position = guiCoord(0, 10, 0, 10),
        backgroundAlpha = 0.0,
        textSize = 16,
        textWrap = true,
        textAlign = "topLeft",
        textFont = "tevurl:fonts/firaCodeRegular.otf"
    })

    local title = teverse.construct("guiTextBox", {
        parent = backdrop,
        size = guiCoord(0, 460, 0, 20),
        position = guiCoord(0.5, -230, 0.5, -80),
        backgroundColour = colour(0.9, 0.9, 0.9),
        textSize = 18,
        dropShadowAlpha = 0.3,
        textAlign = "middle",
        zIndex = 2
    })

    if success then
        title.backgroundColour = colour.rgb(70, 179, 88)
        title.textColour = colour.white()
        title.text = "Uploaded"
        label.text = "Your app has been submitted\n\nApp Id: " .. result.id .. "\nApp Name: " .. result.name .. "\nPckg Id: " .. result.packageId .. "\nPckg Version: " .. result.packageVersion
    else
        title.backgroundColour = colour.rgb(179, 70, 70)
        title.textColour = colour.white()
        title.text = "Something went wrong"
        label.text = result
    end

    teverse.input:waitFor("mouseLeftUp")
    teverse.apps:reload()
end)


test:on("mouseLeftUp", function()
    test.visible = false
    reload.visible = false

    local backdrop = teverse.construct("guiFrame", {
        parent = teverse.coreInterface,
        size = guiCoord(1, 0, 1, 0),
        position = guiCoord(0, 0, 0, 0),
        backgroundColour = colour(.25, .25, .25),
        backgroundAlpha = 0.6,
        zIndex = 1000
    })

    local spinner = teverse.construct("guiIcon", {
        parent = backdrop,
        size = guiCoord(0, 40, 0, 40),
        position = guiCoord(0.5, -20, 0.5, -20),
        iconMax = 40,
        iconColour = colour(1, 1, 1),
        iconType = "faSolid",
        iconId = "spinner",
        iconAlpha = 0.9
    })

    spawn(function()
        while sleep() and spinner.alive do 
            spinner.rotation = spinner.rotation + math.rad(1)
        end
    end)

    teverse.apps:test()
    local success, result = teverse.apps:waitFor("upload")
    spinner:destroy()

    local container = teverse.construct("guiTextBox", {
        parent = backdrop,
        size = guiCoord(0, 460, 0, 120),
        position = guiCoord(0.5, -230, 0.5, -60),
        backgroundColour = colour(1, 1, 1),
        dropShadowAlpha = 0.3,
    })

    local label = teverse.construct("guiTextBox", {
        parent = container,
        size = guiCoord(1.0, -20, 1.0, -20),
        position = guiCoord(0, 10, 0, 10),
        backgroundAlpha = 0.0,
        textSize = 16,
        textWrap = true,
        textAlign = "topLeft",
        textFont = "tevurl:fonts/firaCodeRegular.otf"
    })

    local title = teverse.construct("guiTextBox", {
        parent = backdrop,
        size = guiCoord(0, 460, 0, 20),
        position = guiCoord(0.5, -230, 0.5, -80),
        backgroundColour = colour(0.9, 0.9, 0.9),
        textSize = 18,
        dropShadowAlpha = 0.3,
        textAlign = "middle",
        zIndex = 2
    })

    if success then
        teverse.apps:reload()
    else
        title.backgroundColour = colour.rgb(179, 70, 70)
        title.textColour = colour.white()
        title.text = "Something went wrong"
        label.text = result
    end
end)