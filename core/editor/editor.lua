local lex = require("tevgit:core/editor/lexer.lua")
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
            size = guiCoord(1, -20, 0, 24),
            position = guiCoord(0, 20, 0, 10),
            text = "THIS IS A PROOF OF CONCEPT TEXT EDITOR\nWRITTEN USING OUR LUA API",
            textSize = 12,
            textColour = theme.foreground,
            textAlpha = 0.5,
            textWrap = true,
            backgroundAlpha = 0,
            textFont = "tevurl:fonts/firaCodeBold.otf",
        })

        local numbers = teverse.construct("guiTextBox", {
            parent = container,
            size = guiCoord(0, 30, 1, -50),
            position = guiCoord(0, 0, 0, 50),
            text = "01",
            textSize = 18,
            textColour = theme.foreground,
            textWrap = true,
            backgroundColour = theme.highlighted,
            textFont = "tevurl:fonts/firaCodeBold.otf",
            textAlign = "topRight"
        })

        local editor = teverse.construct("guiRichTextBox", {
            parent = container,
            size = guiCoord(1, -35, 1, -50),
            position = guiCoord(0, 35, 0, 50),
            text = "print(\"Hello World\")\n\n",
            textWrap = true,
            textSize = 18,
            textFont = "tevurl:fonts/firaCodeRegular.otf",
            textEditable = true,
            textMultiline = true,
            name = "editor"
        })

        editor.backgroundColour = theme.background
        editor.textColour = theme.foreground
        
        local function doLex()
            editor:clearColours()
        
            local lines = lex(editor.text)
            local index = 0
            local lastColour = nil
            local lineNumbers = ""
            for lineNumber, line in pairs(lines) do
                local lineCount = 0
                for _, token in pairs(line) do
                    local c = theme[token.type]
                    if c and lastColour ~= c then
                        editor:setColour(index + token.posFirst, c)
                        lastColour = c
                    end
        
                    lineCount = token.posLast
                end
                index = index + lineCount
                lineNumbers = lineNumbers .. string.format("%002d", lineNumber) .. "\n"
            end
            numbers.text = lineNumbers
        end
        
        -- Highlight any pre-entered text
        doLex()
        
        local lastStroke = nil
        editor:on("keyUp", function()
            if lastStroke then 
                return
            end
        
            -- Limit lexxer to once very 0.1 seconds (every keystroke is inefficient)
            lastStroke = true
            doLex()
            sleep(0.1)
            lastStroke = nil
        end)
        
        return container
    end
}