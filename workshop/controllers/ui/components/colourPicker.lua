--[[
    Requires refactoring
]]

local controller = {}

local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local hues = {
	colour(1,0,0),
	colour(1,0,1),
	colour(0,0,1),
	colour(0,1,1),
	colour(0,1,0),
	colour(1,1,0),
	colour(1,0,0),
}

local window = ui.window(shared.workshop.interface, 
                                        "Colour Picker",
                                        guiCoord(0, 300, 0, 186), 
                                        guiCoord(0.5, -150, 0.5, -93), 
                                        false,
                                        true)
window.visible = false
local callback = nil

local startColour = colour(1,0,0)
local currentColour = colour(1,0,0)

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
    backgroundAlpha = 0
})

local hueBarMARKER = engine.construct("guiFrame", hueBar, {
    name = "hueBarMARKER",
    size = guiCoord(1, 0, 0, 1),
    position = guiCoord(0, 0, 0, 0),
    handleEvents=false,
    backgroundAlpha = 0,
    borderColour = colour(0,0,0),
    zIndex = 10,
    borderWidth = 2,
    borderAlpha = 1
})

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

local rLabel = ui.create("guiTextBox", window.content, {
    name = "labelR",
    size = guiCoord(0, 20, 0, 16),
    position = guiCoord(0,200,0,5),
    fontSize = 16,
    textAlpha = 0.6,
    text = "R",
    align = enums.align.topLeft
}, "primaryText")

local rInput = ui.create("guiTextBox", window.content, {
    backgroundAlpha = 0.25,
    readOnly = false,
    multiline = false,
    fontSize = 18,
    name = "r",
    size = guiCoord(1, -220, 0,16),
    position = guiCoord(0, 220, 0, 5),
    text = "1",
    align = enums.align.middle
}, "primary")

local gLabel = rLabel:clone()
gLabel.name = "gLabel"
gLabel.text = "G"
gLabel.parent = window.content
gLabel.position = guiCoord(0, 200, 0, 22)
--themeController.add(gLabel, "primaryText")

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
--themeController.add(bLabel, "primaryText")

local b = rInput:clone()
b.name = "b"
b.parent = window.content
b.position = guiCoord(0, 220, 0, 39)


local hexLabel = rLabel:clone()
hexLabel.name = "hexLabel"
hexLabel.text = "#"
hexLabel.parent = window.content
hexLabel.position = guiCoord(0, 200, 0, 56)
--themeController.add(bLabel, "primaryText")

local HEX = rInput:clone()
HEX.name = "FFFFFF"
HEX.parent = window.content
HEX.position = guiCoord(0, 220, 0, 56)
--  themeController.add(b, "primary")

local preview = engine.construct("guiFrame", window.content, {
    position = guiCoord(0, 220, 0, 73),
    size = guiCoord(1, -220, 0, 16)
})

local function handler()
    local newR = tonumber(rInput.text)
    local newG = tonumber(g.text)
    local newB = tonumber(b.text)
    if not newR or not newG or not newB then return end

    controller.setColour(colour:fromRGB(newR, newG, newB))
end

rInput:textInput(handler)
g:textInput(handler)
b:textInput(handler)
HEX:textInput(function()
    controller.setColour(colour:fromHex(HEX.text), true)
end)

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

            local x = (marker.position.offsetX-2)/colourPickerGradient.absoluteSize.x
            local y = (marker.position.offsetY+2)/colourPickerGradient.absoluteSize.y

            local selectedColour = startColour:lerp(colour(1,1,1), 1-x)
            selectedColour = selectedColour:lerp(colour(0,0,0), y)
            preview.backgroundColour = selectedColour

            rInput.text = tostring(math.floor(selectedColour.r*255))
            g.text = tostring(math.floor(selectedColour.g*255))
            b.text = tostring(math.floor(selectedColour.b*255))
            HEX.text = selectedColour:getHex()
        end

        wait()
    end

    if callback then
        callback(preview.backgroundColour)
    end
end)

colourPickerGradient:mouseLeftPressed(function ()
    while engine.input:isMouseButtonDown(enums.mouseButton.left) do
        local pos = engine.input.mousePosition - colourPickerGradient.absolutePosition
        marker.position = guiCoord(0, pos.x+2, 0, pos.y-2)

        local x = pos.x/colourPickerGradient.absoluteSize.x
        local y = pos.y/colourPickerGradient.absoluteSize.y

        local selectedColour = startColour:lerp(colour(1,1,1), 1-x)
        selectedColour = selectedColour:lerp(colour(0,0,0), y)
        preview.backgroundColour = selectedColour

        rInput.text = tostring(math.floor(selectedColour.r*255))
        g.text = tostring(math.floor(selectedColour.g*255))
        b.text = tostring(math.floor(selectedColour.b*255))
        HEX.text = selectedColour:getHex()
        wait()
    end

    if callback then
        callback(preview.backgroundColour)
    end
end)

controller.setColour = function(c, dontUpdateHex)
    local h,s,l = c:getHSV()
    h=(1-h)*360
    local markerh = math.ceil(h / 60)
    if markerh <= 0 then markerh = 1 end

    local pos = hueBar.absolutePosition
    local size = hueBar.absoluteSize

    local hue = hues[markerh]

    local selected = hue:lerp(hues[markerh+1], ((h - (60*(markerh-1)))/60))

    startColour = selected
    colourPickerGradient.topRightColour = startColour
    colourPickerGradient.bottomRightColour = startColour

    preview.backgroundColour = c

    rInput.text = tostring(math.floor(c.r*255))
    g.text = tostring(math.floor(c.g*255))
    b.text = tostring(math.floor(c.b*255))
    if not dontUpdateHex then
        HEX.text = c:getHex()
    end

    marker.position = guiCoord(0, (s) * colourPickerGradient.absoluteSize.x, 0, (1-l) * colourPickerGradient.absoluteSize.y)
    marker.position = marker.position + guiCoord(0, -2, 0, -2)

    hueBarMARKER.position = guiCoord(0,0,h/360,0)

    if callback then
        callback(preview.backgroundColour)
    end
end

controller.window = window

controller.prompt = function(startColour, cb)
    callback = nil
    controller.setColour(startColour)
    callback = cb
    controller.window.visible = true
end

return controller