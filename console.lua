 -- Copyright (c) 2018 teverse.com
 -- console.lua
 
local windowOutput = engine.guiWindow()
windowOutput.size = guiCoord(0, 400, 0, 200)
windowOutput.position = guiCoord(0, 100, 0, 100)
windowOutput.parent = engine.workshop.interface
windowOutput.text = "Output Console"
windowOutput.name = "windowOutput"
windowOutput.draggable = true
windowOutput.fontSize = 10
windowOutput.backgroundColour = colour(1/20, 1/20, 1/20)
windowOutput.fontFile = normalFontName

local lbl = engine.guiTextBox()
lbl.size = guiCoord(1, 0, 1, 0)
lbl.position = guiCoord(0, 0, 0, 0)
lbl.guiStyle = enums.guiStyle.noBackground
lbl.fontSize = 9
lbl.fontFile = normalFontName
lbl.text = "Test output, lacks stuff."
lbl.readOnly = true
lbl.wrap = true
lbl.multiline = true
lbl.align = enums.align.topLeft
lbl.parent = windowOutput
lbl.textColour = colour(1, 1, 1)

engine.debug:output(function(msg)
	-- This function is deprecated.
	lbl:setText("#7cc0f4[".. os.clock() .."] #ffffff"..msg .. "\n" .. lbl.text:sub(0,500))
end)
