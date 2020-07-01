local createApp = require("tevgit:core/dashboard/appCard.lua")

return {
    name = "Apps",
    iconId = "shapes",
    iconType = "faSolid",
    scrollView = true,
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
            local appGui, button = createApp({
                id = "",
                name = "Learn Code",
                owner = {
                    username = "Teverse"
                }
            })
            appGui.name = "a"
            appGui.parent = appsContainer
            button:on("mouseLeftUp", function()
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
                    local appGui, button = createApp(app)
                    appGui.parent = appsContainer
                    button:on("mouseLeftUp", function()
                        if not loading.visible then
                            loading.text = "Loading App " .. (app.packageNetworked and "Online" or "Offline")
                            loading.visible = true
                            if not app.packageNetworked then
                                teverse.apps:loadRemote(app.id)
                            else
                                teverse.networking:initiate(app.id)
                            end
                            teverse.apps:waitFor("download")
                            loading.visible = false
                        end
                    end)
                end
            else
                subtitle.text = "Server error."
            end
        end)

        local function calculateScrollHeight()
            local y = 0
            for _,v in pairs(appsContainer.children) do
                y = math.max(y, v.absolutePosition.y + 320)
            end

            page.canvasSize = guiCoord(1, 0, 0, y - appsContainer.absolutePosition.y)
        end

        calculateScrollHeight()
        appsContainer:on("childAdded", calculateScrollHeight)
        teverse.input:on("screenResized", calculateScrollHeight)
    end
}