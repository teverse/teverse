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
            cellSize = guiCoord(0, 130, 0, 24),
            cellMargin = guiCoord(0, 10, 0, 15)
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

                appGui:on("mouseLeftUp", function()
                    dialog:destroyChildren()
                    local msg = teverse.construct("guiTextBox", {
                        parent = dialog,
                        size = guiCoord(1.0, -20, 1, -10),
                        position = guiCoord(0, 10, 0, 5),
                        backgroundAlpha = 0,
                        text = "We're updating your app.",
                        textSize = 16,
                        textAlign = "topLeft",
                        textWrap = true
                    })

                    local code, body = teverse.http:put("https://teverse.com/api/apps/" .. app.id .. "/script", 
                        teverse.json:encode(teverse.apps:getSource()), 
                        {
                            ["Authorization"] = "BEARER " .. teverse.userToken,
                            ["Content-Type"] = "application/json"
                        })
                    
                    if code == 200 then
                        msg.text = "Your app was updated! Please note apps may be subject to moderation before becoming public."
                    else
                        msg.text = "Something went wrong."
                    end
                end)
            end

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

            createNew:on("mouseLeftUp", function()
                local newApp = {
                    name = nameBox.text
                }

                dialog:destroyChildren()

                local msg = teverse.construct("guiTextBox", {
                    parent = dialog,
                    size = guiCoord(1.0, -20, 1, -10),
                    position = guiCoord(0, 10, 0, 5),
                    backgroundAlpha = 0,
                    text = "We're creating your new app.",
                    textSize = 16,
                    textAlign = "topLeft",
                    textWrap = true
                })

                teverse.http:post("https://teverse.com/api/apps/", teverse.json:encode(newApp), {
                    ["Authorization"] = "BEARER " .. teverse.userToken,
                    ["Content-Type"] = "application/json"
                }, function(code, body)
                    if code == 201 then
                        local app = teverse.json:decode(body)
                        msg.text = "Deploying script to your new app (" .. app.id .. ")..."
                        local code, body = teverse.http:put("https://teverse.com/api/apps/" .. app.id .. "/script", 
                            teverse.json:encode(teverse.apps:getSource()), 
                            {
                                ["Authorization"] = "BEARER " .. teverse.userToken,
                                ["Content-Type"] = "application/json"
                            })
                        msg.text = "Your new app has been published; please note apps may be subject to moderation before becoming public."
                    else
                        msg.text = "Something went wrong (" .. code .. ")"
                    end
                end)
            end)
        else
            teverse.construct("guiTextBox", {
                parent = appsContainer,
                size = guiCoord(1.0, -20, 1, -10),
                position = guiCoord(0, 10, 0, 5),
                backgroundAlpha = 0,
                text = "Something went wrong",
                textSize = 16,
                textAlign = "topLeft"
            })
        end
    end)
end)