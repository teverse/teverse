-- This script is ran when the user is running a local app/sandbox

local share = teverse.construct("guiTextBox", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 60, 0, 16),
    position = guiCoord(0.5, -65, 1, -20),
    strokeRadius = 4,
    text = "Share",
    textAlign = "middle",
    textSize = 12
})

local reload = teverse.construct("guiTextBox", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 60, 0, 16),
    position = guiCoord(0.5, 5, 1, -20),
    strokeRadius = 4,
    text = "Reload",
    textAlign = "middle",
    textSize = 12
})

reload:on("mouseLeftUp", function()
    teverse.apps:reload()
end)

share:on("mouseLeftUp", function()
    share.visible = false

    local dialog = teverse.construct("guiFrame", {
        parent = teverse.coreInterface,
        size = guiCoord(0, 300, 0, 200),
        position = guiCoord(0.5, -150, 0.5, -100),
        strokeRadius = 4,
        strokeAlpha = 0.3
    })

    local appsContainer = teverse.construct("guiFrame", {
        parent = dialog,
        size = guiCoord(1.0, -10, 1, -30),
        position = guiCoord(0, 5, 0, 5),
        backgroundAlpha = 0
    })

    teverse.guiHelper
        .gridConstraint(appsContainer, {
            cellSize = guiCoord(0, 150, 0, 24),
            cellMargin = guiCoord(0, 15, 0, 15)
        })

    teverse.http:get("https://teverse.com/api/users/" .. teverse.networking.localClient.id .. "/apps", {
        ["Authorization"] = "BEARER " .. teverse.userToken
    }, function(code, body)
        if code == 200 then
            local apps = teverse.json:decode(body)
            for _,app in pairs(apps) do
                local appGui = teverse.construct("guiFrame", {
                    parent = appsContainer,
                    strokeAlpha = 0.1,
                    strokeRadius = 4
                })

                teverse.guiHelper.hoverColour(appGui, colour.rgb(247, 247, 247))

                teverse.construct("guiTextBox", {
                    parent = appGui,
                    size = guiCoord(1.0, -20, 1, -10),
                    position = guiCoord(0, 10, 0, 5),
                    backgroundAlpha = 0,
                    text = app.name,
                    textSize = 16,
                    textAlign = "middleLeft",
                    textFont = "tevurl:fonts/openSansBold.ttf",
                    active = false
                })
            end
        end
    end)

    local nameBox = teverse.construct("guiTextBox", {
        parent = dialog,
        size = guiCoord(1, -105, 0, 20),
        position = guiCoord(0, 5, 1, -25),
        textSize = 16,
        textAlign = "middleLeft",
        text = "Name",
        backgroundColour = colour.rgb(240, 240, 240),
        strokeRadius = 2,
        textEditable = true
    })

    nameBox:on("mouseLeftUp", function()
        nameBox.text = ""
    end)

    local createNew = teverse.construct("guiTextBox", {
        parent = dialog,
        size = guiCoord(0, 100, 0, 20),
        position = guiCoord(1, -105, 1, -25),
        backgroundColour = colour.rgb(216, 100, 89),
        textSize = 18,
        textAlign = "middle",
        textFont = "tevurl:fonts/openSansBold.ttf",
        text = "Create New",
        textColour = colour(1, 1, 1),
        strokeRadius = 2,
        zIndex = 2
    })

end)