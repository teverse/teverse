 -- Copyright (c) 2018 teverse.com
 -- console.lua

local normalFontName = "OpenSans-Regular"
local boldFontName = "OpenSans-Bold"

local windowOutput = engine.guiWindow()
windowOutput.size = guiCoord(0, 400, 0, 200)
windowOutput.position = guiCoord(0, 100, 0, 100)
windowOutput.parent = engine.workshop.interface
windowOutput.text = "Output Console"
windowOutput.name = "windowOutput"
windowOutput.draggable = true
windowOutput.fontSize = 10
windowOutput.guiStyle = enums.guiStyle.basic
windowOutput.backgroundColour = colour(1/20, 1/20, 1/20)
windowOutput.fontFile = normalFontName


local scrollViewOutput = engine.guiScrollView("scrollView")
scrollViewOutput.size = guiCoord(1,-10,1,0)
scrollViewOutput.parent = windowOutput
scrollViewOutput.position = guiCoord(0,0,0,0)
scrollViewOutput.guiStyle = enums.guiStyle.noBackground
scrollViewOutput.canvasSize = guiCoord(1,0,0,1000)


local lbl = engine.guiTextBox()
lbl.size = guiCoord(1, 0, 0, 1000)
lbl.position = guiCoord(0, 0, 0, 0)
lbl.guiStyle = enums.guiStyle.noBackground
lbl.fontSize = 9
lbl.fontFile = normalFontName
lbl.text = "Test output, lacks stuff."
lbl.readOnly = true
lbl.wrap = true
lbl.multiline = true
lbl.align = enums.align.topLeft
lbl.parent = scrollViewOutput
lbl.textColour = colour(1, 1, 1)

local outputLines = {}

engine.debug:output(function(msg)
	if #outputLines > 1000 then
		table.remove(outputLines, 1)
	end

	table.insert(outputLines, {os.clock(), msg})
	local text = ""

	for _,v in pairs (outputLines) do
		text = "#7cc0f4[" .. v[1] .. "] #ffffff" .. v[2] .. "\n" .. text
	end

	-- This function is deprecated.
	lbl:setText(text)
end)
