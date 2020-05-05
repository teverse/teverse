return {
    name = "Develop",
    iconId = "layer-group",
    iconType = "faSolid",
    setup = function(page)
        teverse.construct("guiTextBox", {
            parent = page,
            size = guiCoord(1.0, -20, 0, 48),
            position = guiCoord(0, 10, 0, 10),
            backgroundAlpha = 0,
            text = "Develop",
            textSize = 48,
            textAlign = "middleLeft"
        })

        local newSandboxBtn = teverse.construct("guiFrame", {
            parent = page,
            size = guiCoord(1/3, -20, 0, 70),
            position = guiCoord(0, 10, 0, 60),
            backgroundColour = colour.rgb(74, 140, 122),
            strokeRadius = 2,
            dropShadowAlpha = 0.15,
            strokeAlpha = 0.05
        })

        teverse.guiHelper
            .bind(newSandboxBtn, "xs", {
                size = guiCoord(1, -20, 0, 70),
                position = guiCoord(0, 10, 0, 60)
            })
            .bind(newSandboxBtn, "sm", {
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(0, 10, 0, 60)
            })
            .bind(newSandboxBtn, "lg", {
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(0, 10, 0, 60)
            })
            .hoverColour(newSandboxBtn, colour.rgb(235, 187, 83))
        
        newSandboxBtn:on("mouseLeftUp", function()
            teverse.apps:prompt()
        end)

        teverse.construct("guiTextBox", {
            parent = newSandboxBtn,
            size = guiCoord(0.5, -10, 0, 18),
            position = guiCoord(0.5, 0, 0.5, -9),
            backgroundAlpha = 0,
            text = "Run Script",
            textSize = 18,
            textAlign = "middleLeft",
            textColour = colour(1, 1, 1),
            active = false
            --textFont = "tevurl:fonts/openSansLight.ttf"
        })

        teverse.construct("guiIcon", {
            parent = newSandboxBtn,
            size = guiCoord(0, 40, 0, 40),
            position = guiCoord(0.5, -60, 0.5, -20),
            iconMax = 40,
            iconColour = colour(1, 1, 1),
            iconType = "faSolid",
            iconId = "code",
            iconAlpha = 0.9,
            active = false
        })

        if teverse.dev.localTevGit then
            local workshopBtn = teverse.construct("guiFrame", {
                parent = page,
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(1/3, 10, 0, 0),
                backgroundColour = colour.rgb(74, 140, 122),
                strokeRadius = 2,
                dropShadowAlpha = 0.15,
                strokeAlpha = 0.05
            })

            teverse.guiHelper
                .bind(workshopBtn, "xs", {
                    size = guiCoord(1, -20, 0, 70),
                    position = guiCoord(0, 10, 0, 140)
                })
                .bind(workshopBtn, "sm", {
                    size = guiCoord(1/3, -20, 0, 70),
                    position = guiCoord(1/3, 10, 0, 60)
                })
                .bind(workshopBtn, "lg", {
                    size = guiCoord(1/3, -20, 0, 70),
                    position = guiCoord(1/3, 10, 0, 60)
                })
                .hoverColour(workshopBtn, colour.rgb(235, 187, 83))
            
            workshopBtn:on("mouseLeftUp", function()
                teverse.apps:loadWorkshop()
            end)

            teverse.construct("guiTextBox", {
                parent = workshopBtn,
                size = guiCoord(0.5, -10, 0, 18),
                position = guiCoord(0.5, 0, 0.5, -9),
                backgroundAlpha = 0,
                text = "Workshop",
                textSize = 18,
                textAlign = "middleLeft",
                textColour = colour(1, 1, 1),
                active = false
                --textFont = "tevurl:fonts/openSansLight.ttf"
            })

            teverse.construct("guiIcon", {
                parent = workshopBtn,
                size = guiCoord(0, 40, 0, 40),
                position = guiCoord(0.5, -60, 0.5, -20),
                iconMax = 40,
                iconColour = colour(1, 1, 1),
                iconType = "faSolid",
                iconId = "tools",
                iconAlpha = 0.9,
                active = false
            })
        end
    end
}