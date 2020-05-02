local theme = require("tevgit:core/editor/theme/default.lua")

return {
    create = function()
        local container = teverse.construct("guiRichTextBox", {
            parent = teverse.interface,
            size = guiCoord(1, 0, 1, 0),
            position = guiCoord(0, 0, 0, 0),
            backgroundColour = theme.background
        })

        teverse.construct("guiTextBox", {
            parent = container,
            size = guiCoord(1, -20, 0, 12),
            position = guiCoord(0, 20, 0, 10),
            text = "OUTPUT",
            textSize = 12,
            textColour = theme.foreground,
            textWrap = true,
            backgroundAlpha = 0,
            textFont = "tevurl:fonts/firaCodeBold.otf",
        })

        local text = teverse.construct("guiRichTextBox", {
            parent = container,
            size = guiCoord(1, -40, 1, -34),
            position = guiCoord(0, 20, 0, 34),
            text = "",
            textWrap = true,
            textSize = 18,
            textFont = "tevurl:fonts/firaCodeRegular.otf",
            textMultiline = true,
            backgroundAlpha = 0,
            textColour = theme.foreground,
            name = "output"
        })

        teverse.debug:on("print", function(msg)
            text.text = string.sub(os.date("%H:%M:%S") .. " : " .. msg .. "\n" .. text.text, 0, 500)
        end)

        return container, text
    end
}