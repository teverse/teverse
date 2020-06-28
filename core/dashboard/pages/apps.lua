local function createApp(app)
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

    if (app.iconUrl and app.iconUrl ~= "") then
        local img = teverse.construct("guiImage", {
            size = guiCoord(1, 0, 1, 0),
            image = app.iconUrl,
            parent = appGui,
            active = false, 
            zIndex = -1
        })
    end

    return appGui
end

return {
    name = "Apps",
    iconId = "shapes",
    iconType = "faSolid",
    setup = function(page)
        local loading = teverse.construct("guiTextBox", {
            parent = page,
            size = guiCoord(1.0, 100, 1.0, 100),
            position = guiCoord(0, -50, 0, -50),
            backgroundAlpha = 0.4,
            backgroundColour = colour(0, 0, 0),
            text = "Working...",
            textColour = colour(0,0,0),
            textAlign = "middle",
            visible = false,
            zIndex = 10000
        })

        teverse.construct("guiTextBox", {
            parent = page,
            size = guiCoord(1.0, -20, 0, 48),
            position = guiCoord(0, 10, 0, 10),
            backgroundAlpha = 0,
            text = "Apps",
            textSize = 48,
            textAlign = "middleLeft"
        })

        local subtitle = teverse.construct("guiTextBox", {
            parent = page,
            size = guiCoord(1.0, -20, 0, 18),
            position = guiCoord(0, 10, 0, 55),
            backgroundAlpha = 0,
            text = "Loading Apps",
            textSize = 18,
            textAlign = "middleLeft"
        })
        local appsContainer = teverse.construct("guiFrame", {
            parent = page,
            size = guiCoord(1.0, -20, 1, -100),
            position = guiCoord(0, 10, 0, 80),
            backgroundAlpha = 0
        })

        if _DEVICE:sub(0, 6) == "iPhone" then
            teverse.guiHelper
                .gridConstraint(appsContainer, {
                    cellSize = guiCoord(0, page.absoluteSize.x - 20, 0, page.absoluteSize.x - 20),
                    cellMargin = guiCoord(0, 15, 0, 25)
                })
        else
            teverse.guiHelper
                .gridConstraint(appsContainer, {
                    cellSize = guiCoord(0, 200, 0, 200),
                    cellMargin = guiCoord(0, 15, 0, 25)
                })
        end

        if _DEVICE:sub(0, 6) ~= "iPhone" then
            local appGui = createApp({
                id = "",
                name = "Learn Code",
                owner = {
                    username = "Teverse"
                }
            })
            appGui.name = "a"
            appGui.parent = appsContainer
            appGui:on("mouseLeftUp", function()
                if not loading.visible then
                    loading.visible = false
                    teverse.apps:loadString("require('tevgit:core/tutorials/main.lua')")
                end
            end)
        end
        
        teverse.http:get("https://teverse.com/api/apps", {
            ["Authorization"] = "BEARER " .. teverse.userToken
        }, function(code, body)
            if code == 200 then
                local apps = teverse.json:decode(body)
                subtitle.text = "Found " .. #apps .. " public apps:"
                for _,app in pairs(apps) do
                    local appGui = createApp(app)
                    appGui.parent = appsContainer
                    appGui:on("mouseLeftUp", function()
                        if not loading.visible then
                            loading.text = "Loading App"
                            loading.visible = true
                            teverse.apps:loadRemote(app.id)
                            teverse.apps:waitFor("download")
                            loading.visible = false
                        end
                    end)
                end
            else
                subtitle.text = "Server error."
            end
        end)
    end
}