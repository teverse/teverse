local colourPicker = {}
local uiController = require("tevgit:create/controllers/ui.lua")

local hues = {
	colour(1,0,0),
	colour(1,0,1),
	colour(0,0,1),
	colour(0,1,1),
	colour(0,1,0),
	colour(1,1,0),
	colour(1,0,0),
}

colourPicker.create = function()
	local window = uiController.createWindow(uiController.workshop.interface, 
											guiCoord(0.5, -150, 0.5, -90), 
											guiCoord(0, 300, 0, 180), 
											"Colour Picker")
	local startColour = colour(1,0,0)

  	window.visible = true


	local colourPickerGradient = engine.construct("guiFrameMultiColour", window.content, {
		name = "square",
		size = guiCoord(0, 150, 0, 150),
	  	position = guiCoord(0, 5, 0, 5),
	  	topLeftColour = colour(1,1,1),
	  	topRightColour = startColour,
	  	bottomLeftColour = colour(1,1,1),
	  	bottomRightColour = startColour
	})

	-- To have black on the bottom we need to overlay this...
	engine.construct("guiFrameMultiColour", colourPickerGradient, {
		name = "overlay",
		size = guiCoord(1,0,1,0),
	  	position = guiCoord(0, 0, 0, 0),

	  	topLeftColour = colour(0,0,0),
	  	topLeftAlpha  = 0,

	  	topRightColour = colour(0,0,0),
	  	topRightAlpha  = 0,

	  	bottomLeftColour = colour(0,0,0),
	  	bottomLeftAlpha  = 1,

	  	bottomRightColour = colour(0,0,0),
	  	bottomRightAlpha  = 1,
	})

	local hueBar = engine.construct("guiFrame", window.content, {
		name = "hueBar",
		size = guiCoord(0, 30, 1, -10),
	  	position = guiCoord(0, 160, 0, 5),
	  	alpha = 0
	})

	for i = 1, 6 do
		local colourPickerGradient = engine.construct("guiFrameMultiColour", hueBar, {
			handleEvents = false,
			size = guiCoord(1, 0, 1/6, 1),
		  	position = guiCoord(0, 0, (i-1)*(1/6), 0),
		  	topLeftColour = hues[i],
		  	topRightColour = hues[i],
		  	bottomLeftColour = hues[i+1],
		  	bottomRightColour = hues[i+1]
		})
	end

  	return {
  		window = window
  	}
end

return colourPicker