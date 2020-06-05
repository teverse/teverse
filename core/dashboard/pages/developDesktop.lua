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
    end
}