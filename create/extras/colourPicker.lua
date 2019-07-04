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
											"Colour Picker",
											true)
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

	  	handleEvents = false
	})

	local marker = engine.construct("guiFrame", colourPickerGradient, {
		name = "marker",
		size = guiCoord(0, 6, 0, 6),
	  	position = guiCoord(0, 0, 0, 0),
	  	handleEvents=false,
	  	backgroundColour = colour(1,1,1),
	  	borderColour = colour(0,0,0),
	  	zIndex = 10,
	  	borderWidth = 1,
	  	borderRadius = 6,
	  	borderAlpha = 1
	})

	local hueBar = engine.construct("guiFrame", window.content, {
		name = "hueBar",
		size = guiCoord(0, 30, 1, -10),
	  	position = guiCoord(0, 160, 0, 5),
	  	alpha = 0
	})

	local hueBarMARKER = engine.construct("guiFrame", hueBar, {
		name = "hueBarMARKER",
		size = guiCoord(1, 0, 0, 1),
	  	position = guiCoord(0, 0, 0, 0),
	  	handleEvents=false,
	  	alpha = 0,
	  	borderColour = colour(0,0,0),
	  	zIndex = 10,
	  	borderWidth = 2,
	  	borderAlpha = 1
	})

	hueBar:mouseLeftPressed(function ()
		while engine.input:isMouseButtonDown(enums.mouseButton.left) do
			local pos = engine.input.mousePosition - hueBar.absolutePosition
			local size = hueBar.absoluteSize

			local y = pos.y/hueBar.absoluteSize.y

			local sector = math.ceil(pos.y/(size.y * (1/6)))
			local hue = hues[sector]
			if hue and hues[sector+1] then 

				hueBarMARKER.position = guiCoord(0,0,y,0)

				local selected = hue:lerp(hues[sector+1], (y - ((size.y * ((sector-1)/6))/hueBar.absoluteSize.y)) / (1/6))
				startColour = selected
				colourPickerGradient.topRightColour = startColour
				colourPickerGradient.bottomRightColour = startColour

				local x = marker.absolutePosition.x/colourPickerGradient.absoluteSize.x
				local y = marker.absolutePosition.y/colourPickerGradient.absoluteSize.y

				local selectedColour = startColour:lerp(colour(1,1,1), 1-x)
				selectedColour = selectedColour:lerp(colour(0,0,0), y)

				window.content.backgroundColour = selectedColour

				rInput.text = tostring(selectedColour.r*255)
				g.text = tostring(selectedColour.g*255)
				b.text = tostring(selectedColour.b*255)
				HEX.text = selectedColour:getHex()
			end

			wait()
		end
	end)

	for i = 1, 6 do
		local colourPickerGradient = engine.construct("guiFrameMultiColour", hueBar, {
			handleEvents = false,
			size = guiCoord(1, 0, 1/6, 1),
		  	position = guiCoord(0, 0, (i-1)*(1/6), 0),
		  	topLeftColour = hues[i],
		  	topRightColour = hues[i],
		  	bottomLeftColour = hues[i+1],
		  	bottomRightColour = hues[i+1],
		  	handleEvents = false
		})
	end

	 local rLabel = uiController.create("guiTextBox", window.content, {
      name = "labelR",
      size = guiCoord(0, 20, 0, 16),
      position = guiCoord(0,200,0,5),
      fontSize = 16,
      textAlpha = 0.6,
      text = "R",
      align = enums.align.topLeft
    }, "mainText")

    local rInput = uiController.create("guiTextBox", window.content, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "r",
      size = guiCoord(1, -230, 0,16),
      position = guiCoord(0, 220, 0, 5),
      text = "1",
      align = enums.align.middle
    }, "primary")

    local gLabel = rLabel:clone()
    gLabel.name = "gLabel"
    gLabel.text = "G"
    gLabel.parent = window.content
    gLabel.position = guiCoord(0, 200, 0, 22)
    --themeController.add(gLabel, "mainText")

    local g = rInput:clone()
    g.name = "g"
    g.parent = window.content
    g.position = guiCoord(0, 220, 0, 22)
   -- themeController.add(g, "primary")

    local bLabel = rLabel:clone()
    bLabel.name = "bLabel"
    bLabel.text = "B"
    bLabel.parent = window.content
    bLabel.position = guiCoord(0, 200, 0, 39)
    --themeController.add(bLabel, "mainText")

    local b = rInput:clone()
    b.name = "b"
    b.parent = window.content
    b.position = guiCoord(0, 220, 0, 39)


    local hexLabel = rLabel:clone()
    hexLabel.name = "hexLabel"
    hexLabel.text = "#"
    hexLabel.parent = window.content
    hexLabel.position = guiCoord(0, 200, 0, 55)
    --themeController.add(bLabel, "mainText")

    local HEX = rInput:clone()
    HEX.name = "FFFFFF"
    HEX.parent = window.content
    HEX.position = guiCoord(0, 220, 0, 55)
  --  themeController.add(b, "primary")

    local function handler()
    	local newR = tonumber(rInput.text)
    	local newG = tonumber(g.text)
    	local newB = tonumber(b.text)
    	if not newR or not newG or not newB then return end

     	local newColour = colour(newR, newG, newB)
    end
    rInput:textInput(handler)
    g:textInput(handler)
    b:textInput(handler)

    colourPickerGradient:mouseLeftPressed(function ()
		while engine.input:isMouseButtonDown(enums.mouseButton.left) do
			local pos = engine.input.mousePosition - colourPickerGradient.absolutePosition
			marker.position = guiCoord(0, pos.x+2, 0, pos.y-2)

			local x = pos.x/colourPickerGradient.absoluteSize.x
			local y = pos.y/colourPickerGradient.absoluteSize.y

			local selectedColour = startColour:lerp(colour(1,1,1), 1-x)
			selectedColour = selectedColour:lerp(colour(0,0,0), y)

			window.content.backgroundColour = selectedColour

			rInput.text = tostring(selectedColour.r*255)
			g.text = tostring(selectedColour.g*255)
			b.text = tostring(selectedColour.b*255)
			HEX.text = selectedColour:getHex()
			wait()
		end
	end)


  	return {
  		window = window,
  		setColour = function(c)
  			local h,s,l = c:getHSL()
  			h=h*360

  			local marker = math.ceil(h / 60)
  			if marker <= 0 then marker = 1 end

  			local pos = hueBar.absolutePosition
			local size = hueBar.absoluteSize

			local hue = hues[marker]

			local selected = hue:lerp(hues[marker+1], ((h - (60*(marker-1)))/60))

			startColour = selected
			colourPickerGradient.topRightColour = startColour
			colourPickerGradient.bottomRightColour = startColour

			hueBarMARKER.position = guiCoord(0,0,h/360,0)


  		end
  	}
end

return colourPicker