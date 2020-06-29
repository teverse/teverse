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

    local img = teverse.construct("guiImage", {
        size = guiCoord(1, 0, 1, 0),
        parent = appGui,
        active = false, 
        zIndex = -1
    })

    if (app.iconUrl and app.iconUrl ~= "") then
        img.image = app.iconUrl
    else
        img.image = "tevurl:img/tevapp.png"
    end

    return appGui
end

return {
    name = "Develop",
    iconId = "layer-group",
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
                    teverse.apps:promptAppDirectory()
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

        teverse.http:get("https://teverse.com/api/users/" .. teverse.networking.localClient.id .. "/apps", {
            ["Authorization"] = "BEARER " .. teverse.userToken
        }, function(code, body)
            if code == 200 then
                local apps = teverse.json:decode(body)
                for _,app in pairs(apps) do
                    local appGui = createApp(app)
                    appGui.parent = appsContainer
                    appGui:on("mouseLeftUp", function()
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

    end
}