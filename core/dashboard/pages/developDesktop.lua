local createApp = require("tevgit:core/dashboard/appCard.lua")

return {
    name = "Develop",
    iconId = "layer-group",
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
            text = "Develop",
            textSize = 48,
            textAlign = "middleLeft"
        })

        local btns = {
            {
                "Run packaged .tevapp",
                "archive",
                function()
                    teverse.apps:promptApp()
                end
            },
            {
                "Run unpacked app",
                "code",
                function ()

                    -- backwards compatibility
                    if _TEV_VERSION_MINOR < 25 then
                        return teverse.apps:promptAppDirectory()
                    end

                    local recents = teverse.apps:recentDirectories()
                    if #recents == 0 then
                        teverse.apps:promptAppDirectory()
                    else
                        local backdrop = teverse.construct("guiFrame", {
                            parent = teverse.interface,
                            size = guiCoord(1, 100, 1, 100),
                            position = guiCoord(0, -50, 0, -50),
                            backgroundColour = colour(0, 0, 0),
                            backgroundAlpha = 0.0,
                            zIndex = 10
                        })

                        teverse.tween:begin(backdrop, 0.2, {
                            backgroundAlpha = 0.8
                        })

                        local dialog = teverse.construct("guiFrame", {
                            parent = backdrop,
                            size = guiCoord(0, 200, 0, 100),
                            position = guiCoord(0.5, -100, 0.5, -50),
                            backgroundColour = colour(1, 1, 1),
                            strokeRadius = 2,
                            dropShadowAlpha = 0.15,
                            strokeAlpha = 0.05
                        })

                        teverse.tween:begin(dialog, 0.2, {
                            size = guiCoord(0, 500, 0, 200),
                            position = guiCoord(0.5, -250, 0.5, -100)
                        }, "outQuad")

                        local prompt = teverse.construct("guiIcon", {
                            parent = dialog,
                            size = guiCoord(0.3, 0, 1, 0),
                            position = guiCoord(0.7, 0, 0, 0),
                            iconMax = 40,
                            iconColour = colour.rgb(74, 140, 122),
                            backgroundAlpha = 0.05,
                            backgroundColour = colour(0, 0, 0),
                            iconType = "faSolid",
                            iconId = "folder-open"
                        })

                        prompt:on("mouseLeftUp", function()
                            teverse.apps:promptAppDirectory()
                        end)

                        local y = 0
                        for _,v in pairs(recents) do

                            local trigger = teverse.construct("guiTextBox", {
                                parent = dialog,
                                size = guiCoord(0.7, -20, 0, 18),
                                position = guiCoord(0, 10, 0, y),
                                backgroundAlpha = 0.0,
                                text = v,
                                textSize = 18
                            })

                            trigger:on("mouseLeftUp", function()
                                teverse.apps:runRecent(v)
                            end)

                            y = y + 20
                        end
                    end
                end
            }
        }

        if teverse.dev.localTevGit then
            table.insert(btns, {
                "Run workshop (in dev)",
                "tools",
                function ( )
                    teverse.apps:loadWorkshop()
                end
            })
        end

        local btnWidth = 1 / #btns
        for i, cb in pairs(btns) do
            local newSandboxBtn = teverse.construct("guiFrame", {
                parent = page,
                size = guiCoord(btnWidth, -20, 0, 70),
                position = guiCoord((i-1)*btnWidth, 10, 0, 60),
                backgroundColour = colour.rgb(74, 140, 122),
                strokeRadius = 2,
                dropShadowAlpha = 0.15,
                strokeAlpha = 0.05
            })

            teverse.guiHelper
                .bind(newSandboxBtn, "xs", {
                    size = guiCoord(1, -20, 0, 70),
                    position = guiCoord(0, 10, 0, 60 + ((i - 1) * 90))
                })
                .bind(newSandboxBtn, "md", {
                    size = guiCoord(btnWidth, -20, 0, 70),
                    position = guiCoord((i-1)*btnWidth, 10, 0, 60)
                })
                .hoverColour(newSandboxBtn, colour.rgb(235, 187, 83))
        
            newSandboxBtn:on("mouseLeftUp", cb[3])

            teverse.construct("guiTextBox", {
                parent = newSandboxBtn,
                size = guiCoord(0.75, -20, 0, 18),
                position = guiCoord(0.25, 10, 0.5, -9),
                backgroundAlpha = 0,
                text = cb[1],
                textSize = 18,
                textAlign = "middle",
                textColour = colour(1, 1, 1),
                active = false
                --textFont = "tevurl:fonts/openSansLight.ttf"
            })

            teverse.construct("guiIcon", {
                parent = newSandboxBtn,
                size = guiCoord(0, 40, 0, 40),
                position = guiCoord(0.25, -20, 0.5, -20),
                iconMax = 40,
                iconColour = colour(1, 1, 1),
                iconType = "faSolid",
                iconId = cb[2],
                iconAlpha = 0.9,
                active = false
            })
        end

        local appsContainer = teverse.construct("guiFrame", {
            parent = page,
            size = guiCoord(1.0, -20, 1, -150),
            position = guiCoord(0, 10, 0, 150),
            backgroundAlpha = 0
        })

        teverse.guiHelper
            .gridConstraint(appsContainer, {
                cellSize = guiCoord(0, 200, 0, 200),
                cellMargin = guiCoord(0, 15, 0, 25)
            })

        teverse.guiHelper
            .bind(appsContainer, "xs", {
                size = guiCoord(1, -20, 1, -330),
                position = guiCoord(0, 10, 0, 330)
            })
            .bind(appsContainer, "lg", {
                size = guiCoord(1, 0, 1, -150),
                position = guiCoord(0, 0, 0, 150)
            })

        teverse.http:get("https://teverse.com/api/users/" .. teverse.networking.localClient.id .. "/apps", {
            ["Authorization"] = "BEARER " .. teverse.userToken
        }, function(code, body)
            if code == 200 then
                local apps = teverse.json:decode(body)
                for _,app in pairs(apps) do
                    local appGui, launchButton = createApp(app)
                    appGui.parent = appsContainer
                    launchButton:on("mouseLeftUp", function()
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
                y = math.max(y, v.absolutePosition.y + 390)
            end

            appsContainer.size = guiCoord(1.0, -20, 0, y - appsContainer.absolutePosition.y)
            page.canvasSize = guiCoord(1, 0, 0, y - appsContainer.absolutePosition.y)
        end

        calculateScrollHeight()
        appsContainer:on("childAdded", calculateScrollHeight)
        teverse.input:on("screenResized", calculateScrollHeight)
    end
}