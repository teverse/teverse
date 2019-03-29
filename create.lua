 -- Copyright (c) 2019 teverse.com
 -- create mode
 -- Alot of code borrowed from workshop.lua.

 -- This script should get access to 'engine.workshop' APIs.

local darkTheme = {
	font = "OpenSans-Regular",
	fontBold = "OpenSans-Bold",

	mainBg  = colour:fromRGB(66, 66, 76),
	mainTxt = colour:fromRGB(255, 255, 255),

	secondaryBg  = colour:fromRGB(55, 55, 66),
	secondaryText  = colour:fromRGB(255, 255, 255),

	primaryBg  = colour:fromRGB(188, 205, 224),
	primaryText  = colour:fromRGB(10, 10, 10),

	toolSelected = colour(1, 1, 1),
	toolHovered = colour(0.9, 0.9, 0.9),
	toolDeselected = colour(0.6, 0.6, 0.6)
}

local lightTheme = {
	font = "OpenSans-Regular",
	fontBold = "OpenSans-Bold",

	mainBg  = colour:fromRGB(244, 244, 249),
	mainTxt = colour:fromRGB(32, 32, 35),

	toolSelected = colour(1, 1, 1),
	toolHovered = colour(0.9, 0.9, 0.9),
	toolDeselected = colour:fromRGB(219, 219, 219)
}

theme = darkTheme


-- Setup Start Enviroment
engine.graphics.clearColour = colour:fromRGB(155, 181, 242)
engine.graphics.ambientColour = colour:fromRGB(166, 166, 166)

local directionalLight = engine.light("light1")	
directionalLight.offsetPosition = vector3(3,4,0)	
directionalLight.parent = workspace	
directionalLight.type = enums.lightType.directional
directionalLight.offsetRotation = quaternion():setEuler(-.2,0.2,0)
directionalLight.shadows = true

local basePlate = engine.block("base")
basePlate.colour = colour(1, 1, 1)
basePlate.size = vector3(100, 1, 100)
basePlate.position = vector3(0, -1, 0)
basePlate.parent = workspace
basePlate.workshopLocked = true

local starterBlock = engine.block("red")
starterBlock.colour = colour(1,0,0)
starterBlock.size = vector3(1,1,1)
starterBlock.position = vector3(-22, 2, -22)
starterBlock.parent = workspace

local starterBlock2 = engine.block("green")
starterBlock2.colour = colour(0,1,0)
starterBlock2.size = vector3(0.8,1,0.2)
starterBlock2.position = vector3(-23, 2, -22)
starterBlock2.parent = workspace

local starterBlock3 = engine.block("blue")
starterBlock3.colour = colour(0,0.2,1)
starterBlock3.size = vector3(1,0.5,1)
starterBlock3.position = vector3(-22.5, 2.75, -22)
starterBlock3.parent = workspace


-- Selection System

local boundingBox = engine.block("_CreateMode_boundingBox")
boundingBox.wireframe = true
boundingBox.castsShadows = false
boundingBox.static = true
boundingBox.physics = false
boundingBox.colour = colour(1, 0.8, 0.8)
boundingBox.opacity = 0
boundingBox.size = vector3(0,0,0)


local selectedItems = {}


--Calculate median of vector
--modified from http://lua-users.org/wiki/SimpleStats
local function median( t, component )
  local temp={}

  for k,v in pairs(t) do
    table.insert(temp, v.position[component])
  end

  table.sort( temp )

  if math.fmod(#temp,2) == 0 then
    return ( temp[#temp/2] + temp[(#temp/2)+1] ) / 2
  else
    return temp[math.ceil(#temp/2)]
  end
end

local function calculateVertices(block)
	local vertices = {}
	for x = -1,1,2 do
		for y = -1,1,2 do
			for z = -1,1,2 do
				table.insert(vertices, block.position + block.rotation* (vector3(x,y,z) *block.size/2))
			end
		end
	end
	return vertices
end

local function calculateBounding(items)
	local min, max;

			for _,v in pairs(items) do
				if not min then min = v.position; max=v.position end
				local vertices = calculateVertices(v)
				for i,v in pairs(vertices) do
					min = min:min(v)
					max = max:max(v)
				end
			end

	return (max-min), (max - (max-min)/2)
end

local isCalculating = false
local function calculateBoundingBox()
	if isCalculating then return end
	isCalculating=true
	

	if #selectedItems < 1 then
		boundingBox.size = vector3(0,0,0)
		boundingBox.opacity = 0
		isCalculating = false
	return end

	boundingBox.opacity = 0.5

	local size, pos = calculateBounding(selectedItems)
	boundingBox.size = size
	boundingBox.position = pos

	--engine.tween:begin(boundingBox, .025, {size = max-min, position = max - (max-min)/2}, "inQuad")

	isCalculating = false
end

local boundingBoxListeners = {}
local function addBoundingListener(block)
	table.insert(boundingBoxListeners, block:changed(calculateBoundingBox))
end
local function removeBoundingListener(block)
	table.insert(boundingBoxListeners, block:changed(calculateBoundingBox))
end

local lastHover = nil
engine.graphics:frameDrawn(function(events, frameNumber)	
	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition ) -- accepts vector2 or number,number

	if mouseHit and not disableDefaultClickActions and not mouseHit.object.workshopLocked and mouseHit.object.emissiveColour == colour(0.0, 0.0, 0.0) then 
			
		if lastHover and lastHover ~= mouseHit.object and lastHover.emissiveColour == colour(0.05, 0.05, 0.05) then
			lastHover.emissiveColour = colour(0.0, 0.0, 0.0)
		end

		mouseHit.object.emissiveColour = colour(0.05, 0.05, 0.05)
		lastHover = mouseHit.object
	elseif (not mouseHit or mouseHit.object.workshopLocked) and lastHover and lastHover.emissiveColour == colour(0.05, 0.05, 0.05) then
		lastHover.emissiveColour = colour(0.0, 0.0, 0.0)
		lastHover = nil
	end
end)


-- Clean out any deleted items.
local function validateItems()
	for i,v in pairs(selectedItems) do
		if not v or v.isDestroyed then 
			table.remove(selectedItems, i)
		end
	end
end


engine.input:mouseLeftReleased(function( input )
	if input.systemHandled or disableDefaultClickActions then return end

	validateItems()

	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
	if not mouseHit or mouseHit.object.workshopLocked then
		if mouseHit and mouseHit.object.name == "_CreateMode_" then return end -- dont deselect
		-- User clicked empty space, deselect everything??#
		for _,v in pairs(selectedItems) do
			v.emissiveColour = colour(0.0, 0.0, 0.0)
		end
		selectedItems = {}

		for _,v in pairs(boundingBoxListeners) do
			v:disconnect()
		end
		boundingBoxListeners = {}

		calculateBoundingBox()
		return
	end

	local doSelect = true

	if not engine.input:isKeyDown(enums.key.leftShift) then
		-- deselect everything that's already selected and move on
		for _,v in pairs(selectedItems) do
			v.emissiveColour = colour(0.0, 0.0, 0.0)
		end
		selectedItems = {}

		for _,v in pairs(boundingBoxListeners) do
			v:disconnect()
		end
		boundingBoxListeners = {}

		calculateBoundingBox()
	else
		for i,v in pairs(selectedItems) do
			if v == mouseHit.object then
				table.remove(selectedItems, i)
				removeBoundingListener(v)
				v.emissiveColour = colour(0.0, 0.0, 0.0)
				doSelect = false
			end
		end
	end

	if doSelect then

		mouseHit.object.emissiveColour = colour(0.025, 0.025, 0.15)

		table.insert(selectedItems, mouseHit.object)
		addBoundingListener(mouseHit.object)
		calculateBoundingBox()

	end

end)


-- End Selection System


-- Camera

local zoomStep = 3
local rotateStep = -0.0045
local moveStep = 0.5 -- how fast the camera moves

local camera = workspace.camera

-- Setup the initial position of the camera
camera.position = vector3(11, 5, 10)
camera:lookAt(vector3(0,0,0))
-- Camera key input values
local cameraKeyEventLooping = false
local cameraKeyArray = {
	[enums.key.w] = vector3(0, 0, -1),
	[enums.key.s] = vector3(0, 0, 1),
	[enums.key.a] = vector3(-1, 0, 0),
	[enums.key.d] = vector3(1, 0, 0),
	[enums.key.q] = vector3(0, -1, 0),
	[enums.key.e] = vector3(0, 1, 0)
}

engine.input:mouseScrolled(function( input )
	if input.systemHandled then return end

	local cameraPos = camera.position
	cameraPos = cameraPos + (camera.rotation * (cameraKeyArray[enums.key.w] * input.movement.y * zoomStep))
	camera.position = cameraPos	

end)

engine.input:mouseMoved(function( input )
	if engine.input:isMouseButtonDown( enums.mouseButton.right ) then
		local pitch = quaternion():setEuler(input.movement.y * rotateStep, 0, 0)
		local yaw = quaternion():setEuler(0, input.movement.x * rotateStep, 0)

		-- Applied seperately to avoid camera flipping on the wrong axis.
		camera.rotation = yaw * camera.rotation;
		camera.rotation = camera.rotation * pitch
		
		--updatePosition()
	end
end)

engine.input:keyPressed(function( inputObj )
	if inputObj.systemHandled then return end

	if cameraKeyArray[inputObj.key] and not cameraKeyEventLooping then
		cameraKeyEventLooping = true
		repeat
			local cameraPos = camera.position

			for key, vector in pairs(cameraKeyArray) do
				-- check this key is pressed (still)
				if engine.input:isKeyDown(key) then
					cameraPos = cameraPos + (camera.rotation * vector * moveStep)
				end
			end

			cameraKeyEventLooping = (cameraPos ~= camera.position)
			camera.position = cameraPos	

			wait(0.001)

		until not cameraKeyEventLooping
	end

	if inputObj.key == enums.key.f and #selectedItems>0 then
		local mdn = vector3(median(selectedItems, "x"), median(selectedItems, "y"),median(selectedItems, "z") )
		--camera.position = mdn + (camera.rotation * vector3(0,0,1) * 15)
		--print(mdn)
		engine.tween:begin(camera, .2, {position = mdn + (camera.rotation * vector3(0,0,1) * 15)}, "outQuad")

	end
end)

-- End Camera

-- Main GUI

function generateIcon(icon, size, parent)
	local img = engine.guiImage()
	img.size = guiCoord(0, size, 0, size)
	img.position = guiCoord(.5, -size/2, 0.5, -size/2)
	img.parent = parent
	img.guiStyle = enums.guiStyle.noBackground
	img.imageColour = theme.mainTxt
	img.texture = "fa:" .. icon
	img.handleEvents = false
	return img
end

local mainGuiFrame = engine.workshop.interface

local mainFrame = engine.guiFrame()
mainFrame.size = guiCoord(0, 132, 0, 36)
mainFrame.parent = mainGuiFrame
mainFrame.position = guiCoord(0, 15, 0, -40)
mainFrame.backgroundColour = theme.mainBg
mainFrame.alpha = 0.985
mainFrame.guiStyle = enums.guiStyle.rounded

local toolBarMain = engine.guiFrame()
toolBarMain.size = guiCoord(1, -6, 0, 30)
toolBarMain.position = guiCoord(0, 3, 0, 3)
toolBarMain.parent = mainFrame
toolBarMain.alpha = 0

local logFrame = engine.guiFrame()
logFrame.size = guiCoord(1, 0, 0, 220)
logFrame.parent = mainGuiFrame
logFrame.position = guiCoord(0, 0, 1, 0)
logFrame.backgroundColour = theme.mainBg
logFrame.alpha = 0.98
logFrame.visible = false

local logFrameTextBox = engine.guiTextBox()
logFrameTextBox.size = guiCoord(1, -4, 1, -26)
logFrameTextBox.position = guiCoord(0, 2, 0, 0)
logFrameTextBox.guiStyle = enums.guiStyle.noBackground
logFrameTextBox.fontSize = 18
logFrameTextBox.fontFile = theme.font
logFrameTextBox.text = "No output loaded."
logFrameTextBox.readOnly = true
logFrameTextBox.wrap = true
logFrameTextBox.multiline = true
logFrameTextBox.align = enums.align.topLeft
logFrameTextBox.parent = logFrame
logFrameTextBox.textColour = theme.mainTxt

local codeInputBox = engine.guiTextBox()
codeInputBox.parent = logFrame
codeInputBox.size = guiCoord(1, 0, 0, 23)
codeInputBox.position = guiCoord(0, 0, 1, -25)
codeInputBox.backgroundColour = theme.secondaryBg
codeInputBox.fontSize = 16
codeInputBox.fontFile = theme.font
codeInputBox.text = " "
codeInputBox.readOnly = false
codeInputBox.wrap = true
codeInputBox.multiline = false
codeInputBox.align = enums.align.middleLeft

--Create mode
local createModeFrame = engine.guiFrame()
createModeFrame.size = guiCoord(0, 85, 0, 36)
createModeFrame.parent = mainGuiFrame
createModeFrame.position = guiCoord(0, 157, 0, -40)
createModeFrame.backgroundColour = theme.mainBg
createModeFrame.alpha = 0.985
createModeFrame.guiStyle = enums.guiStyle.rounded

local createModeText = engine.guiTextBox()
createModeText.size = guiCoord(1, -10, 1, -6)
createModeText.position = guiCoord(0, 10, 0, 3)
createModeText.guiStyle = enums.guiStyle.noBackground
createModeText.fontSize = 20
createModeText.fontFile = theme.font
createModeText.text = "Mode:"
createModeText.readOnly = true
createModeText.align = enums.align.middleLeft
createModeText.parent = createModeFrame
createModeText.textColour = theme.mainTxt
createModeText.alpha = 0.8

local createModeImage = engine.guiImage()
createModeImage.size = guiCoord(0, 20, 0, 17)
createModeImage.position = guiCoord(1, -30, 0.5, -8.5)
createModeImage.parent = createModeFrame
createModeImage.guiStyle = enums.guiStyle.noBackground
createModeImage.imageColour = theme.mainTxt
createModeImage.texture = "local:block.png"

delay(function()
	engine.tween:begin(mainFrame, .5, {position = guiCoord(0, 15, 0, 15)}, "inOutBack")
	wait(0.1)
	engine.tween:begin(createModeFrame, .5, {position = guiCoord(0, 157, 0, 15)}, "inOutBack")
end, .01)


local settingsFrame = engine.guiFrame()
settingsFrame.size = guiCoord(0, 36, 0, 36)
settingsFrame.parent = mainGuiFrame
settingsFrame.position = guiCoord(1, -51, 0, 15)
settingsFrame.backgroundColour = theme.mainBg
settingsFrame.alpha = 0.7
settingsFrame.guiStyle = enums.guiStyle.rounded
settingsFrame.zIndex = 1

local settingsButton = generateIcon("s-bars", 20, settingsFrame)

local settingsBar = engine.guiFrame()
settingsBar.size = guiCoord(0, 288, 1, 0)
settingsBar.parent = mainGuiFrame
settingsBar.position = guiCoord(1, 0, 0, 0)
settingsBar.backgroundColour = theme.mainBg
settingsBar.alpha = 0.99

local logoImage = engine.guiImage()
logoImage.size = guiCoord(0, 180, 0, 37)
logoImage.position = guiCoord(0,20,0,15)
logoImage.parent = settingsBar
logoImage.guiStyle = enums.guiStyle.noBackground
logoImage.imageColour = colour(1,1,1)
logoImage.alpha = 0.75
logoImage.texture = "local:logo250.png";

local saveBtn = engine.guiTextBox()
saveBtn.hoverCursor = "fa:s-hand-pointer"
saveBtn.parent = settingsBar
saveBtn.backgroundColour = theme.primaryBg
saveBtn.textColour = theme.primaryText
saveBtn.alpha = 1
saveBtn.size = guiCoord(0, 40, 0, 32)
saveBtn.position = guiCoord(0, 20, 0, 68)
saveBtn.fontFile = theme.fontBold
saveBtn.fontSize = 26
saveBtn.align = enums.align.middleLeft
saveBtn.guiStyle = enums.guiStyle.rounded
saveBtn.wrap = false
saveBtn.text = ""

local saveBtnIcon = generateIcon("s-save", 20, saveBtn)
saveBtnIcon.position = guiCoord(0, 10, 0.5, -10)
saveBtnIcon.imageColour = theme.primaryText
saveBtnIcon.alpha = 0.85

local saveAsBtn = engine.guiTextBox()
saveAsBtn.hoverCursor = "fa:s-hand-pointer"
saveAsBtn.parent = settingsBar
saveAsBtn.backgroundColour = theme.primaryBg
saveAsBtn.textColour = theme.primaryText
saveAsBtn.alpha = 1
saveAsBtn.size = guiCoord(0, 40, 0, 32)
saveAsBtn.position = guiCoord(0, 70, 0, 68)
saveAsBtn.fontFile = theme.fontBold
saveAsBtn.fontSize = 26
saveAsBtn.align = enums.align.middleLeft
saveAsBtn.guiStyle = enums.guiStyle.rounded
saveAsBtn.wrap = false
saveAsBtn.text = ""

local saveAsBtnIcon = generateIcon("r-save", 20, saveAsBtn)
saveAsBtnIcon.position = guiCoord(0, 10, 0.5, -10)
saveAsBtnIcon.imageColour = theme.primaryText
saveAsBtnIcon.alpha = 0.85

local openBtn = engine.guiTextBox()
openBtn.hoverCursor = "fa:s-hand-pointer"
openBtn.parent = settingsBar
openBtn.backgroundColour = theme.primaryBg
openBtn.textColour = theme.primaryText
openBtn.alpha = 1
openBtn.size = guiCoord(0, 40, 0, 32)
openBtn.position = guiCoord(0, 120, 0, 68)
openBtn.fontFile = theme.fontBold
openBtn.fontSize = 26
openBtn.align = enums.align.middleLeft
openBtn.guiStyle = enums.guiStyle.rounded
openBtn.wrap = false
openBtn.text = ""

local openBtnIcon = generateIcon("s-folder-open", 20, openBtn)
openBtnIcon.position = guiCoord(0, 10, 0.5, -10)
openBtnIcon.imageColour = theme.primaryText
openBtnIcon.alpha = 0.85

saveBtn:mouseFocused(function()
	saveBtn.text = "          Save"
	engine.tween:begin(saveBtn, 0.1, {size = guiCoord(0, 90, 0, 32)}, "inOutQuad")
	engine.tween:begin(saveAsBtn, 0.1, {position = guiCoord(0, 120, 0, 68)}, "inOutQuad")
	engine.tween:begin(openBtn, 0.1, {position = guiCoord(0, 170, 0, 68)}, "inOutQuad")
end)

saveBtn:mouseUnfocused(function()
	saveBtn.text = ""
	engine.tween:begin(saveBtn, 0.1, {size = guiCoord(0, 40, 0, 32)}, "inOutQuad")
	engine.tween:begin(saveAsBtn, 0.1, {position = guiCoord(0, 70, 0, 68)}, "inOutQuad")
	engine.tween:begin(openBtn, 0.1, {position = guiCoord(0, 120, 0, 68)}, "inOutQuad")
end)

saveBtn:mouseLeftPressed(function()engine.workshop:saveGame()end)

saveAsBtn:mouseFocused(function()
	saveAsBtn.text = "          Save as"
	engine.tween:begin(saveAsBtn, 0.1, {size = guiCoord(0, 110, 0, 32)}, "inOutQuad")
	engine.tween:begin(openBtn, 0.1, {position = guiCoord(0, 190, 0, 68)}, "inOutQuad")
end)

saveAsBtn:mouseLeftPressed(function()engine.workshop:saveGameAsDialogue()end)

saveAsBtn:mouseUnfocused(function()
	saveAsBtn.text = ""
	engine.tween:begin(saveAsBtn, 0.1, {size = guiCoord(0, 40, 0, 32)}, "inOutQuad")
	engine.tween:begin(openBtn, 0.1, {position = guiCoord(0, 120, 0, 68)}, "inOutQuad")
end)

openBtn:mouseFocused(function()
	openBtn.text = "         Open"
	engine.tween:begin(openBtn, 0.1, {size = guiCoord(0, 90, 0, 32)}, "inOutQuad")
end)

openBtn:mouseUnfocused(function()
	openBtn.text = ""
	engine.tween:begin(openBtn, 0.1, {size = guiCoord(0, 40, 0, 32)}, "inOutQuad")
end)

openBtn:mouseLeftPressed(function()engine.workshop:openFileDialogue()end)

engine.construct("guiFrame", settingsBar, {
	size=guiCoord(0, 125, 0, 32),
	position=guiCoord(0, 20, 0, 110),
	backgroundColour = theme.primaryBg,
	guiStyle = enums.guiStyle.rounded
}, function(holder)
	engine.construct("guiTextBox", holder, {
		size=guiCoord(1,-28,1,0),
		position=guiCoord(0,28,0,0),
		guiStyle = enums.guiStyle.noBackground,
		textColour=theme.primaryText,
		align=enums.align.middleLeft,
		fontSize=26,
		text="Publish",
		fontFile= theme.fontBold
	})

	engine.construct("guiImage", holder, {
		size=guiCoord(0,20,0,20),
		position=guiCoord(0,5,0,5),
		imageColour=theme.primaryText,
		guiStyle = enums.guiStyle.noBackground,
		texture="fa:s-cloud"
	})
end)


settingsFrame:mouseFocused(function()
	engine.tween:begin(settingsFrame, 0.1, {alpha=0.985}, "inOutQuad")
end)

settingsFrame:mouseUnfocused(function()
	engine.tween:begin(settingsFrame, 0.1, {alpha=0.7}, "inOutQuad")
end)

local isExpandedSettings = false
local function toggleSettings()
	isExpandedSettings = not isExpandedSettings
	if isExpandedSettings then
		engine.tween:begin(settingsBar, 0.25, {position=guiCoord(1, -288, 0, 0)}, "inOutQuad")
		settingsButton.texture = "fa:s-minus"
	else
		engine.tween:begin(settingsBar, 0.25, {position=guiCoord(1, 0, 0, 0)}, "inOutQuad")
		settingsButton.texture = "fa:s-bars"
	end
end

settingsFrame.hoverCursor = "fa:s-hand-pointer"

settingsFrame:mouseLeftReleased(function()
	toggleSettings()
end)

-- End Main Gui

-- Create mode system

local loadingMode = false
local function modeClickHandler()
	--placeholder
	if loadingMode then return end
	loadingMode = true

	engine.tween:begin(createModeImage, .25, {position = guiCoord(1, -30, 1, 0)}, "inOutBack", function()
		createModeImage.position = guiCoord(1,-30,0,-20)
		engine.tween:begin(createModeImage, .25, {position = guiCoord(1, -30, 0.5, -8.5)}, "inOutBack", function()
			loadingMode = false
		end)
	end)
end

createModeImage:mouseLeftPressed(modeClickHandler)
createModeFrame:mouseLeftPressed(modeClickHandler)
createModeText:mouseLeftPressed(modeClickHandler)

-- Create mode system end

-- Output System

local inAction = false
engine.input:keyPressed(function( inputObj )
	if inputObj.systemHandled or inAction then return end

	if inputObj.key == enums.key.number0 then
		inAction = true
		if logFrame.visible then
			engine.tween:begin(logFrame, 0.5, {position = guiCoord(0, 0, 1, 0)}, "outQuad", function()
				logFrame.visible = false
				inAction = false
			end)
		else
			logFrame.visible = true
			engine.tween:begin(logFrame, 0.5, {position = guiCoord(0, 0, 1, -220)}, "outQuad", function()
				inAction = false
			end)
		end
	elseif inputObj.key == enums.key.space then
		for _,v in pairs(selectedItems) do
			v.emissiveColour = colour(0.0, 0.0, 0.0)
		end
		selectedItems = {}

		for _,v in pairs(boundingBoxListeners) do
			v:disconnect()
		end
		boundingBoxListeners = {}

		calculateBoundingBox()
	elseif inputObj.key == enums.key.escape then
		toggleSettings()
	end
end)

local outputLines = {}

engine.debug:output(function(msg, type)

	if #outputLines > 10 then
		table.remove(outputLines, 1)
	end
	table.insert(outputLines, {os.clock(), msg, type})

	local text = ""

	for _,v in pairs (outputLines) do
		local colour = (v[3] == 1) and "#ff0000" or "#ffffff"
		text = string.format("#7cc0f4[%.3f] %s%s\n%s", v[1], colour, v[2], text)
	end

	text = #outputLines .. " lines. " .. text:len() .. " characters\n" .. text 

	-- This function is deprecated.
	logFrameTextBox:setText(text)

end)

local lastCmd = ""
codeInputBox:keyPressed(function(inputObj)
	if inputObj.key == enums.key['return'] then

		if (codeInputBox.text == "clear" or codeInputBox.text == " clear") then
			outputLines = {}
			logFrameTextBox:setText("")
			codeInputBox.text = ""
			return
		end
		-- Note: workshop:loadString is not the same as the standard lua loadstring 
		-- This method will load and run the string immediately
		-- Returns a boolean indicating success and an error message if success is false.
		local input = string.gsub(codeInputBox.text, "##", "#")

		local success, result = engine.workshop:loadString(input)
		lastCmd = input

		print(" > " .. input:sub(0,200))
		codeInputBox.text = ""
		if not success then
			error(result, 2)
		end
	elseif inputObj.key == enums.key['up'] then
		codeInputBox.text = lastCmd
	end
end)

-- End output system

-- Tool System

local activeTool = 0
local tools = {}

local function addTool(image, activate, deactivate, defaultData)
	local toolID = #tools + 1;

	local toolButton = engine.guiImage()
	toolButton.size = guiCoord(0, 24, 0, 24)
	toolButton.position = guiCoord(0, 5 + (30 * #tools), 0, 3)
	toolButton.parent = toolBarMain
	toolButton.guiStyle = enums.guiStyle.noBackground
	toolButton.imageColour = theme.toolDeselected
	toolButton.texture = image;

	local t =toolButton:mouseLeftReleased(function()
		-- deactivate current active tool
		if tools[activeTool] then
			tools[activeTool].gui.imageColour = theme.toolDeselected
			if tools[activeTool].deactivate then
				tools[activeTool].deactivate(activeTool)
			end
		end

		if activeTool == toolID then
			activeTool = 0
		else
			activeTool = toolID
			tools[toolID].gui.imageColour = theme.toolSelected
			if tools[activeTool].activate then
				tools[activeTool].activate(toolID)
			end
		end
	end)


	table.insert(tools, {["id"]=toolID, ["gui"]=toolButton, ["data"]=defaultData and defaultData or {}, ["activate"] = activate, ["deactivate"] = deactivate})
	return tools[toolID]
end

engine.input:keyPressed(function( inputObj )
	if inputObj.systemHandled then return end

	local runTool = nil
	if inputObj.key == enums.key.number1 then
		runTool = 1
	elseif inputObj.key == enums.key.number2 then
		runTool = 2
	elseif inputObj.key == enums.key.number3 then
		runTool = 3
	elseif inputObj.key == enums.key.number4 then
		runTool = 4
	end

	if runTool then
		if tools[activeTool] then
			tools[activeTool].gui.imageColour = theme.toolDeselected
			if tools[activeTool].deactivate then
				tools[activeTool].deactivate(activeTool)
			end
		end

		if activeTool == runTool then
			activeTool = 0
		else
			activeTool = runTool
			tools[runTool].gui.imageColour = theme.toolSelected
			if tools[activeTool].activate then
				tools[activeTool].activate(runTool)
			end
		end
	end
end)

-- End tool system


-- Tools

local moveGrid = "1" -- cache between tools.
local rotateCache = "45"

	local roundToMultiple = function(number, multiple)
		if multiple == 0 then 
			return number 
		end

		return ((number % multiple) > multiple/2) and number + multiple - number%multiple or number - number%multiple
	end

	function round(num, numDecimalPlaces)
	  local mult = 10^(numDecimalPlaces or 0)
	  return math.floor(num * mult + 0.5) / mult
	end

-- Drag Tool
local toolBarDragBtn = addTool("local:hand.png", function(id)
	--activated

	--Accessory Frame
	local accessoryFrame = engine.guiFrame()
	accessoryFrame.size = guiCoord(0, 85, 0, 36)
	accessoryFrame.parent = mainGuiFrame
	accessoryFrame.position = guiCoord(0, 252, 0, -40)
	accessoryFrame.backgroundColour = theme.mainBg
	accessoryFrame.alpha = 0.985
	accessoryFrame.guiStyle = enums.guiStyle.rounded

	tools[id].data.accessoryFrame = accessoryFrame

	local accessoryText = engine.guiTextBox()
	accessoryText.size = guiCoord(0, 40, 1, -6)
	accessoryText.position = guiCoord(0, 10, 0, 3)
	accessoryText.guiStyle = enums.guiStyle.noBackground
	accessoryText.fontSize = 20
	accessoryText.fontFile = theme.font
	accessoryText.text = "Grid:"
	accessoryText.readOnly = true
	accessoryText.align = enums.align.middleLeft
	accessoryText.parent = accessoryFrame
	accessoryText.textColour = theme.mainTxt
	accessoryText.alpha = 0.8

	local inputGrid = engine.guiTextBox()
	inputGrid.name = "inputGrid"
	inputGrid.size = guiCoord(0, 38, 1, -8)
	inputGrid.position = guiCoord(0, 42, 0, 4)
	inputGrid.backgroundColour = theme.secondaryBg
	inputGrid.guiStyle = enums.guiStyle.rounded
	inputGrid.fontSize = 20
	inputGrid.fontFile = theme.font
	inputGrid.text = moveGrid
	inputGrid.readOnly = false
	inputGrid.align = enums.align.middle
	inputGrid.parent = accessoryFrame
	inputGrid.textColour = theme.secondaryText
	inputGrid.alpha = 0.8

	local hovers = {}
	local expanded = false

	local function updateSize(didFocus)
		if didFocus and expanded then return end 

		local focused = false
		for o,v in pairs(hovers) do
			if v then focused = true end
		end

		if focused and not expanded then
			engine.tween:begin(accessoryFrame, .25, {size = guiCoord(0, 220, 0, 36)}, "inOutQuad")
			expanded = true
		elseif not focused and expanded then
			engine.tween:begin(accessoryFrame, .25, {size = guiCoord(0, 85, 0, 36)}, "inOutQuad")
			expanded = false
		end
	end

	local function focusedHandler()
		hovers[self.object] = true
		updateSize(true)
	end

	local function unfocusedHandler()
		hovers[self.object] = false
		updateSize()
	end

	accessoryFrame:mouseFocused(focusedHandler)
	accessoryText:mouseFocused(focusedHandler)
	inputGrid:mouseFocused(focusedHandler)
	
	accessoryFrame:mouseUnfocused(unfocusedHandler)
	accessoryText:mouseUnfocused(unfocusedHandler)
	inputGrid:mouseUnfocused(unfocusedHandler)


	local x = 90
	for i,v in ipairs(tools[id].data.axis) do 
		local lbl = engine.guiTextBox()
		lbl.size = guiCoord(0, 13, 1, -6)
		lbl.position = guiCoord(0, x, 0, 3)
		lbl.guiStyle = enums.guiStyle.noBackground
		lbl.fontSize = 20
		lbl.fontFile = theme.font
		lbl.text = string.upper(v[1])
		lbl.readOnly = true
		lbl.align = enums.align.middleLeft
		lbl.parent = accessoryFrame
		lbl.textColour = theme.mainTxt
		lbl.alpha = 0.8

		local boolProp = engine.guiButton()
		boolProp.name = "bool"
		boolProp.parent = accessoryFrame
		boolProp.position = guiCoord(0,x+12,0.5,-8)
		boolProp.size = guiCoord(0, 20, 0, 20)
		boolProp.text = ""
		boolProp.guiStyle = enums.guiStyle.checkBox
		boolProp.selected = v[2]

		boolProp:mouseLeftReleased(function()
			tools[id].data.axis[i][2] = not tools[id].data.axis[i][2]
			boolProp.selected = tools[id].data.axis[i][2]
		end)


		lbl:mouseFocused(focusedHandler)
		boolProp:mouseFocused(focusedHandler)
		lbl:mouseUnfocused(unfocusedHandler)
		boolProp:mouseUnfocused(unfocusedHandler)
		x = x + 42
	end

	local isDown = false
	local applyRot = 0

	engine.tween:begin(accessoryFrame, .5, {position = guiCoord(0, 252, 0, 15)}, "inOutBack")

	-- Store event handler so we can disconnect it later.
	tools[id].data.mouseDownEvent = engine.input:mouseLeftPressed(function ( inp )
		if inp.systemHandled then return end
	
		isDown = true
		applyRot = 0
		if (#selectedItems > 0) then

			local hit, didExclude = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, selectedItems)
			
			-- Didexclude is false if the user didnt drag starting from one of the selected items.
			if didExclude == false then return end

			wait(.25)
			if not isDown then return end -- they held the button down, so let's start dragging

			local gridStep = tonumber(inputGrid.text)
			if not gridStep then gridStep = 0 else gridStep = math.abs(gridStep) end
			inputGrid.text = tostring(gridStep)

			disableDefaultClickActions = true -- will disable the main selection system for 0.2 seconds after user ends drag

			hit = hit and hit[1] or nil
			local startPosition = hit and hit.hitPosition or vector3(0,0,0)
			local lastPosition = startPosition
			local startRotation = selectedItems[1].rotation
			local offsets = {}
			--local lowestPoint = selectedItems[1].position.y

			for i,v in pairs(selectedItems) do
				if i > 1 then 
					--lowestPoint = math.min(lowestPoint, v.position.y-(v.size.y/2))
					local relative = startRotation:inverse() * v.rotation;	
					local positionOffset = (relative*selectedItems[1].rotation):inverse() * (v.position - selectedItems[1].position) 
					offsets[v] = {positionOffset, relative}
				end
			end


			local lastRot = applyRot

			while isDown and activeTool == id do
				local currentHit = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, selectedItems)
				if #currentHit >= 1 then 
					currentHit = currentHit[1]

					local forward = (currentHit.object.rotation * currentHit.hitNormal):normal()-- * quaternion:setEuler(0,math.rad(applyRot),0)
	
					local currentPosition = currentHit.hitPosition + (forward * (selectedItems[1].size/2)) --+ (selectedItems[1].size/2)

					if gridStep > 0 then
						for i, v in pairs(tools[id].data.axis) do
							if v[2] then
								currentPosition[v[1]] = roundToMultiple(currentPosition[v[1]], gridStep)
							end
						end
					end

					if lastPosition ~= currentPosition or lastRot ~= applyRot then
						lastRot = applyRot
						lastPosition = currentPosition

						local targetRot = startRotation * quaternion:setEuler(0,math.rad(applyRot),0)

						engine.tween:begin(selectedItems[1], .2, {position = currentPosition,
														  		   rotation = targetRot }, "outQuad")

						--selectedItems[1].position = currentPosition 
						--selectedItems[1].rotation = startRotation * quaternion:setEuler(0,math.rad(applyRot),0)
						--print(selectedItems[1].name)

						for i,v in pairs(selectedItems) do
							if i > 1 then 
								--v.position = (currentPosition) + (offsets[v][2]*selectedItems[1].rotation) * offsets[v][1]
								--v.rotation = offsets[v][2]*selectedItems[1].rotation 

								engine.tween:begin(v, .2, {position = (currentPosition) + (offsets[v][2]*targetRot) * offsets[v][1],
														   rotation = offsets[v][2]*targetRot }, "outQuad")
							end
						end

					end
				end
				--calculateBoundingBox()
				wait()
			end
		end

	end)

	tools[id].data.keyDownEvent = engine.input:keyPressed(function ( inp )
		if inp.systemHandled then return end
		
		if isDown then
			if inp.key == enums.key.r then
				applyRot = applyRot + 45/2
			end
		end

		if inp.key == enums.key.t then
			inputGrid.text = "0"
		end
	end)

	tools[id].data.mouseUpEvent = engine.input:mouseLeftReleased(function ( inp )
		if inp.systemHandled then return end
		isDown = false
		wait(0.2)
		calculateBoundingBox()
		if not isDown and activeTool == id then
			disableDefaultClickActions = false
		end
	end)

end,
function (id)
	--deactivated
	local f = tools[id].data.accessoryFrame
	moveGrid = tostring(tonumber(f.inputGrid.text))
	if moveGrid == "nil" then moveGrid = "10" end

	engine.tween:begin(f, .3, {position = guiCoord(0, 252, 0, -40)}, "inOutBack", function()
		f:destroy()
	end)

	tools[id].data.accessoryFrame = nil

	tools[id].data.mouseDownEvent:disconnect()
	tools[id].data.mouseUpEvent:disconnect()
	tools[id].data.keyDownEvent:disconnect()

	tools[id].data.mouseDownEvent = nil
	tools[id].data.mouseUpEvent = nil
	tools[id].data.keyDownEvent = nil
end, {axis={{"x", true},{"y", false},{"z", true}}})


-- End Drag Tool

delay(function()
	activeTool = toolBarDragBtn.id
	toolBarDragBtn.gui.imageColour = theme.toolSelected
	toolBarDragBtn.activate(activeTool)
end, .2)




local toolBarMoveBtn = addTool("local:move.png", function(id)
	--activated
	
	--Accessory Frame
	local accessoryFrame = engine.guiFrame()
	accessoryFrame.size = guiCoord(0, 85, 0, 36)
	accessoryFrame.parent = mainGuiFrame
	accessoryFrame.position = guiCoord(0, 252, 0, -40)
	accessoryFrame.backgroundColour = theme.mainBg
	accessoryFrame.alpha = 0.985
	accessoryFrame.guiStyle = enums.guiStyle.rounded

	tools[id].data.accessoryFrame = accessoryFrame

	local accessoryText = engine.guiTextBox()
	accessoryText.size = guiCoord(0, 40, 1, -6)
	accessoryText.position = guiCoord(0, 10, 0, 3)
	accessoryText.guiStyle = enums.guiStyle.noBackground
	accessoryText.fontSize = 20
	accessoryText.fontFile = theme.font
	accessoryText.text = "Grid:"
	accessoryText.readOnly = true
	accessoryText.align = enums.align.middleLeft
	accessoryText.parent = accessoryFrame
	accessoryText.textColour = theme.mainTxt
	accessoryText.alpha = 0.8

	local inputGrid = engine.guiTextBox("inputGrid")
	inputGrid.size = guiCoord(0, 38, 1, -8)
	inputGrid.position = guiCoord(0, 42, 0, 4)
	inputGrid.backgroundColour = theme.secondaryBg
	inputGrid.guiStyle = enums.guiStyle.rounded
	inputGrid.fontSize = 20
	inputGrid.fontFile = theme.font
	inputGrid.text = moveGrid
	inputGrid.readOnly = false
	inputGrid.align = enums.align.middle
	inputGrid.parent = accessoryFrame
	inputGrid.textColour = theme.secondaryText
	inputGrid.alpha = 0.8

	local hovers = {}
	local expanded = false

	local function updateSize(didFocus)
		if didFocus and expanded then return end 

		local focused = false
		for o,v in pairs(hovers) do
			if v then focused = true end
		end

		if focused and not expanded then
			engine.tween:begin(accessoryFrame, .25, {size = guiCoord(0, 220, 0, 36)}, "inOutQuad")
			expanded = true
		elseif not focused and expanded then
			engine.tween:begin(accessoryFrame, .25, {size = guiCoord(0, 85, 0, 36)}, "inOutQuad")
			expanded = false
		end
	end

	local function focusedHandler()
		hovers[self.object] = true
		updateSize(true)
	end

	local function unfocusedHandler()
		hovers[self.object] = false
		updateSize()
	end

	accessoryFrame:mouseFocused(focusedHandler)
	accessoryText:mouseFocused(focusedHandler)
	inputGrid:mouseFocused(focusedHandler)
	
	accessoryFrame:mouseUnfocused(unfocusedHandler)
	accessoryText:mouseUnfocused(unfocusedHandler)
	inputGrid:mouseUnfocused(unfocusedHandler)


	local x = 90
	for i,v in ipairs(tools[id].data.axis) do 
		local lbl = engine.guiTextBox()
		lbl.size = guiCoord(0, 13, 1, -6)
		lbl.position = guiCoord(0, x, 0, 3)
		lbl.guiStyle = enums.guiStyle.noBackground
		lbl.fontSize = 20
		lbl.fontFile = theme.font
		lbl.text = string.upper(v[1])
		lbl.readOnly = true
		lbl.align = enums.align.middleLeft
		lbl.parent = accessoryFrame
		lbl.textColour = theme.mainTxt
		lbl.alpha = 0.8

		local boolProp = engine.guiButton()
		boolProp.name = "bool"
		boolProp.parent = accessoryFrame
		boolProp.position = guiCoord(0,x+12,0.5,-8)
		boolProp.size = guiCoord(0, 20, 0, 20)
		boolProp.text = ""
		boolProp.guiStyle = enums.guiStyle.checkBox
		boolProp.selected = v[2]

		boolProp:mouseLeftReleased(function()
			tools[id].data.axis[i][2] = not tools[id].data.axis[i][2]
			boolProp.selected = tools[id].data.axis[i][2]
		end)


		lbl:mouseFocused(focusedHandler)
		boolProp:mouseFocused(focusedHandler)
		lbl:mouseUnfocused(unfocusedHandler)
		boolProp:mouseUnfocused(unfocusedHandler)
		x = x + 42
	end

	local isDown = false

	engine.tween:begin(accessoryFrame, .5, {position = guiCoord(0, 252, 0, 15)}, "inOutBack")


	local updateHandles;
	-- Store event handler so we can disconnect it later.

	local gridGuideline = engine.block("_CreateMode_")
	tools[id].data.gridGuideline = gridGuideline
	gridGuideline.size = vector3(0,0,0)
	gridGuideline.colour = colour(1, 1, 1)
	gridGuideline.parent = workspace
	gridGuideline.opacity = 0
	gridGuideline.workshopLocked = true
	gridGuideline.castsShadows = false

	tools[id].data.handles = {}
	local components = {"x", "y", "z"}
	local c = 1
	local o = 0
	for i = 1,6 do
		local componentIndex = c
		local component = components[c]
		local face = vector3(0,0,0)
		face[component] = o == 0 and o-1 or o

		local handle = engine.block("_CreateMode_")
		handle.castsShadows = false
		handle.opacity = 0
		handle.size = vector3(0.1,0.1,0.1)
		handle.colour = colour(c==1 and 1 or 0, c==2 and 1 or 0, c==3 and 1 or 0)
		handle.emissiveColour = colour(c==1 and .5 or 0, c==2 and .5 or 0, c==3 and .5 or 0)

		handle.workshopLocked = true

		handle:mouseLeftPressed(function()
			disableDefaultClickActions = true
			gridGuideline.size = vector3(300, 0.1, 300)
			gridGuideline.rotation = handle.rotation
			gridGuideline.position = handle.position
			if component == "x" then
				gridGuideline.rotation =  gridGuideline.rotation * quaternion():setEuler(math.rad(-45),math.rad(-45),0)
			end

			local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
			if not mouseHit or not mouseHit.object == gridGuideline then
				return print("Error, couldn't cast ray to guideline.")
			end

			local mouseoffsets = {}
			for _,v in pairs(selectedItems) do
				mouseoffsets[v] = (mouseHit.hitPosition - v.position)
			end

			local lastHit = mouseHit.hitPosition

			local gridStep = tonumber(inputGrid.text)
			if not gridStep then gridStep = 0 else gridStep = math.abs(gridStep) end
			inputGrid.text = tostring(gridStep)
			repeat 
				if activeTool == id then
					--Face camera on one Axis
					gridGuideline.position = handle.position
					if component == "x" then
						local xVector1 = vector3(0, gridGuideline.position.y,gridGuideline.position.z)
						local xVector2 = vector3(0, workspace.camera.position.y, workspace.camera.position.z)

						local lookAt = gridGuideline.rotation:setLookRotation( xVector1 - xVector2 )
						gridGuideline.rotation =  lookAt * quaternion():setEuler(math.rad(45),0,0)
					else
						local pos1 = gridGuideline.position
						pos1[component] = 0

						local pos2 = workspace.camera.position
						pos2[component] = 0

						local lookAt = gridGuideline.rotation:setLookRotation( pos1 - pos2 )
						gridGuideline.rotation =  lookAt * quaternion():setEuler(math.rad(45),0,0)
					end

					local mouseHits = engine.physics:rayTestScreenAllHits( engine.input.mousePosition )
					local mouseHit = nil
					-- We only want the gridGuideline
					for _,hit in pairs(mouseHits) do
						if hit.object == gridGuideline then
							mouseHit = hit
							goto skip_loop
						end
					end
					::skip_loop::

					if mouseHit and mouseHit.object == gridGuideline and lastHit ~= mouseHit.hitPosition then
						local target = mouseHit.hitPosition
						lastHit = target

						for _,v in pairs(selectedItems) do
							if mouseoffsets[v] then
								local newPos = target - mouseoffsets[v]
								local pos = v.position
								if gridStep > 0 and tools[id].data.axis[componentIndex] then
									pos[component] = roundToMultiple(newPos[component], gridStep)
								else
									pos[component] = newPos[component]
								end
								--v.position = pos
								engine.tween:begin(v, .05, {position = pos}, "inOutQuad")
							end
						end
					end
				end
				wait()
			until not engine.input:isMouseButtonDown(enums.mouseButton.left) or not activeTool == id
			delay(function() disableDefaultClickActions = false end, 1)
			if activeTool == id then
				gridGuideline.size = vector3(0,0,0)
			end
		end)
		
		table.insert(tools[id].data.handles, {handle, face})
		if i % 2 == 0 then
			c=c+1
			o = 0
		else
			o = o + 1
		end
	end

	updateHandles = function()
		if boundingBox.size == vector3(0,0,0) then
			for _,v in pairs(tools[id].data.handles) do
				v[1].size = vector3(0,0,0)
				v[1].opacity = 0
			end
		else
			for _,v in pairs(tools[id].data.handles) do
				v[1].position = boundingBox.position + boundingBox.rotation* ((v[2] * boundingBox.size/2) + (v[2]*1.5)) 
				v[1]:lookAt(boundingBox.position)
				v[1].size = vector3(0.1, 0.1, 0.25)
				v[1].opacity = 1
			end
		end
	end

	tools[id].data.keyDownEvent = engine.input:keyPressed(function ( inp )
		if inp.key == enums.key.t then
			inputGrid.text = "0"
		end
	end)

	tools[id].data.boundingEvent = boundingBox:changed(updateHandles)
	updateHandles()
end,
function (id)
	--deactivated
	local f = tools[id].data.accessoryFrame
	moveGrid = tostring(tonumber(f.inputGrid.text))

	if moveGrid == "nil" then moveGrid = "10" end
	engine.tween:begin(f, .3, {position = guiCoord(0, 252, 0, -40)}, "inOutBack", function()
		f:destroy()
	end)

	tools[id].data.keyDownEvent:disconnect()
	tools[id].data.keyDownEvent = nil

	tools[id].data.boundingEvent:disconnect()
	tools[id].data.boundingEvent = nil

	tools[id].data.accessoryFrame = nil

	for _,v in pairs(tools[id].data.handles) do
		v[1]:destroy()
	end
	tools[id].data.gridGuideline:destroy()
	tools[id].data.gridGuideline = nil
	tools[id].data.handles = nil

end, {world=false, axis={{"x", true},{"y", true},{"z", true}}})


--local toolBarRotateBtn = addTool("local:rotate.png")

local toolBarRotateBtn = addTool("local:rotate.png", function(id)
	--activated

	local stepFrame = engine.guiFrame()
	stepFrame.size = guiCoord(0, 85, 0, 36)
	stepFrame.parent = mainGuiFrame
	stepFrame.position = guiCoord(0, 252, 0, -40)
	stepFrame.backgroundColour = theme.mainBg
	stepFrame.alpha = 0.985
	stepFrame.guiStyle = enums.guiStyle.rounded

	tools[id].data.stepFrame = stepFrame
	engine.tween:begin(stepFrame, .5, {position = guiCoord(0, 252, 0, 15)}, "inOutBack")

	local stepText = engine.guiTextBox()
	stepText.size = guiCoord(0, 40, 1, -6)
	stepText.position = guiCoord(0, 10, 0, 3)
	stepText.guiStyle = enums.guiStyle.noBackground
	stepText.fontSize = 20
	stepText.fontFile = theme.font
	stepText.text = "Step:"
	stepText.readOnly = true
	stepText.align = enums.align.middleLeft
	stepText.parent = stepFrame
	stepText.textColour = theme.mainTxt
	stepText.alpha = 0.8

	local inputGrid = engine.guiTextBox("inputGrid")
	inputGrid.size = guiCoord(0, 38, 1, -8)
	inputGrid.position = guiCoord(0, 42, 0, 4)
	inputGrid.backgroundColour = theme.secondaryBg
	inputGrid.guiStyle = enums.guiStyle.rounded
	inputGrid.fontSize = 20
	inputGrid.fontFile = theme.font
	inputGrid.text = rotateCache
	inputGrid.readOnly = false
	inputGrid.align = enums.align.middle
	inputGrid.parent = stepFrame
	inputGrid.textColour = theme.secondaryText
	inputGrid.alpha = 0.8
	
	--Accessory Frame
	local accessoryFrame = engine.guiFrame()
	accessoryFrame.size = guiCoord(0, 227, 0, 24)
	accessoryFrame.parent = mainGuiFrame
	accessoryFrame.position = guiCoord(0, -230, 0, 61)
	accessoryFrame.backgroundColour = theme.mainBg
	accessoryFrame.alpha = 0.985
	accessoryFrame.guiStyle = enums.guiStyle.rounded

	tools[id].data.accessoryFrame = accessoryFrame

	local axis = {"x", "y", "z"}
	local xTotal = 27


	local mainText = engine.guiTextBox()
		mainText.size = guiCoord(1, -6, 0, 21)
		mainText.position = guiCoord(0, 3, 0, 2)
		mainText.guiStyle = enums.guiStyle.noBackground
		mainText.fontSize = 20
		mainText.fontFile = theme.font
		mainText.text = "Nothing Selected"
		mainText.readOnly = true
		mainText.align = enums.align.middle
		mainText.parent = accessoryFrame
		mainText.textColour = theme.mainTxt
		mainText.alpha = 0.8

	for _,v in pairs(axis) do
		local accessoryText = engine.guiTextBox()
		accessoryText.size = guiCoord(0, 24, 0, 21)
		accessoryText.position = guiCoord(0, 10, 0, xTotal)
		accessoryText.guiStyle = enums.guiStyle.noBackground
		accessoryText.fontSize = 20
		accessoryText.fontFile = theme.fontBold
		accessoryText.text = string.upper(v) .. ":"
		accessoryText.readOnly = true
		accessoryText.align = enums.align.middleLeft
		accessoryText.parent = accessoryFrame
		accessoryText.textColour = theme.mainTxt
		accessoryText.alpha = 0.8

		local currentValText = engine.guiTextBox()
		currentValText.size = guiCoord(0, 50, 0, 21)
		currentValText.position = guiCoord(0, 24, 0, xTotal)
		currentValText.guiStyle = enums.guiStyle.rounded
		currentValText.backgroundColour = theme.secondaryBg
		currentValText.fontSize = 18
		currentValText.fontFile = theme.font
		currentValText.text = "0"
		currentValText.readOnly = false
		currentValText.align = enums.align.middle
		currentValText.parent = accessoryFrame
		currentValText.textColour = theme.secondaryText
		currentValText.alpha = 0.8

		local infoText = engine.guiTextBox()
		infoText.size = guiCoord(1, -85, 0, 21)
		infoText.position = guiCoord(0, 80, 0, xTotal)
		infoText.guiStyle = enums.guiStyle.rounded
		infoText.backgroundColour = theme.secondaryText
		infoText.fontSize = 18
		infoText.fontFile = theme.font
		infoText.text = "Click and Drag here"
		infoText.readOnly = true
		infoText.align = enums.align.middle
		infoText.parent = accessoryFrame
		infoText.textColour = theme.secondaryBg
		infoText.alpha = 0.8

		local isDown = false

		infoText:mouseLeftPressed(function()
			isDown = true

				local totalSize, totalposition = calculateBounding(selectedItems)
	

				local startRotation = quaternion:setEuler(0,0,0)

				local offsets = {}

				for _,v in pairs(selectedItems) do
					local relative = startRotation:inverse() * v.rotation;	
					local positionOffset = (relative*startRotation):inverse() * (v.position - totalposition) 
					offsets[v] = {positionOffset, relative}
				end

			local last = engine.input.mousePosition.x
			local rotation = quaternion():getEuler()

			local gridStep = tonumber(inputGrid.text)
			if not gridStep then gridStep = 0 else gridStep = math.abs(gridStep) end
			inputGrid.text = tostring(gridStep)
			gridStep = gridStep /2

			while isDown do
				local current = engine.input.mousePosition.x
				local offset = current - last
				last = current

				rotation[v] = rotation[v] + math.rad(offset)

			

				currentValText.text = tostring(round(math.deg(rotation[v]),2))


				local newEuler = rotation:clone()

				if gridStep > 0 then
						local de = math.deg(newEuler[v])

									newEuler[v] = math.rad(roundToMultiple(de, gridStep))
				
								end

				local targetRot = quaternion:setEuler(newEuler)

					

						--selectedItems[1].position = currentPosition 
						--selectedItems[1].rotation = startRotation * quaternion:setEuler(0,math.rad(applyRot),0)
						--print(selectedItems[1].name)

						for i,v in pairs(selectedItems) do
							
								--v.position = (currentPosition) + (offsets[v][2]*selectedItems[1].rotation) * offsets[v][1]
								--v.rotation = offsets[v][2]*selectedItems[1].rotation 

								engine.tween:begin(v, .2, {position = (totalposition) + (offsets[v][2]*targetRot) * offsets[v][1],
														   rotation = offsets[v][2]*targetRot }, "outQuad")
							
						end



				--for i,item in pairs(selectedItems) do
				--	item.rotation = quaternion:setEuler(rotation)
				--end

				wait()
			end
		end)

		infoText:mouseLeftReleased(function()
			isDown = false
		end)

		xTotal = xTotal + 25
	end

	--accessoryFrame.size = guiCoord(0, 227, 0, xTotal + 3)


	engine.tween:begin(accessoryFrame, .5, {position = guiCoord(0, 15, 0, 61)}, "inOutBack")


	tools[id].data.keyDownEvent = engine.input:keyPressed(function ( inp )
		if inp.key == enums.key.t then
			inputGrid.text = "0"
		end
	end)

	local function checkSelectedItems()
		if #selectedItems == 0 then
			mainText.text = "Please select an item."
			engine.tween:begin(accessoryFrame, .3, {size = guiCoord(0, 227, 0, 24)}, "inOutQuad")
		else
			mainText.text = #selectedItems .. " items selected."
			engine.tween:begin(accessoryFrame, .3, {size = guiCoord(0, 227, 0, xTotal+3)}, "inOutQuad")
		end
	end

	tools[id].data.boundingEvent = boundingBox:changed(checkSelectedItems)
	checkSelectedItems()
end,
function (id)
	--deactivated
	local f = tools[id].data.accessoryFrame

	engine.tween:begin(f, .3, {position = guiCoord(0, -227, 0, 61)}, "inOutBack", function()
		f:destroy()
	end)

	local s = tools[id].data.stepFrame
	rotateCache = tostring(tonumber(s.inputGrid.text))

	if rotateCache == "nil" then rotateCache = "45" end
	engine.tween:begin(s, .3, {position = guiCoord(0, 252, 0, -40)}, "inOutBack", function()
		s:destroy()
	end)

	tools[id].data.boundingEvent:disconnect()
	tools[id].data.boundingEvent = nil

	tools[id].data.keyDownEvent:disconnect()
	tools[id].data.keyDownEvent = nil

	tools[id].data.accessoryFrame = nil
	tools[id].data.stepFrame = nil



end, {world=false})

local toolBarScaleBtn = addTool("local:scale.png", function(id)
	--activated
	
	--Accessory Frame
	local accessoryFrame = engine.guiFrame()
	accessoryFrame.size = guiCoord(0, 85, 0, 36)
	accessoryFrame.parent = mainGuiFrame
	accessoryFrame.position = guiCoord(0, 252, 0, -40)
	accessoryFrame.backgroundColour = theme.mainBg
	accessoryFrame.alpha = 0.985
	accessoryFrame.guiStyle = enums.guiStyle.rounded

	tools[id].data.accessoryFrame = accessoryFrame

	local accessoryText = engine.guiTextBox()
	accessoryText.size = guiCoord(0, 40, 1, -6)
	accessoryText.position = guiCoord(0, 10, 0, 3)
	accessoryText.guiStyle = enums.guiStyle.noBackground
	accessoryText.fontSize = 20
	accessoryText.fontFile = theme.font
	accessoryText.text = "Grid:"
	accessoryText.readOnly = true
	accessoryText.align = enums.align.middleLeft
	accessoryText.parent = accessoryFrame
	accessoryText.textColour = theme.mainTxt
	accessoryText.alpha = 0.8

	local inputGrid = engine.guiTextBox("inputGrid")
	inputGrid.size = guiCoord(0, 38, 1, -8)
	inputGrid.position = guiCoord(0, 42, 0, 4)
	inputGrid.backgroundColour = theme.secondaryBg
	inputGrid.guiStyle = enums.guiStyle.rounded
	inputGrid.fontSize = 20
	inputGrid.fontFile = theme.font
	inputGrid.text = moveGrid
	inputGrid.readOnly = false
	inputGrid.align = enums.align.middle
	inputGrid.parent = accessoryFrame
	inputGrid.textColour = theme.secondaryText
	inputGrid.alpha = 0.8

	local hovers = {}
	local expanded = false

	local function updateSize(didFocus)
		if didFocus and expanded then return end 

		local focused = false
		for o,v in pairs(hovers) do
			if v then focused = true end
		end

		if focused and not expanded then
			engine.tween:begin(accessoryFrame, .25, {size = guiCoord(0, 220, 0, 36)}, "inOutQuad")
			expanded = true
		elseif not focused and expanded then
			engine.tween:begin(accessoryFrame, .25, {size = guiCoord(0, 85, 0, 36)}, "inOutQuad")
			expanded = false
		end
	end

	local function focusedHandler()
		hovers[self.object] = true
		updateSize(true)
	end

	local function unfocusedHandler()
		hovers[self.object] = false
		updateSize()
	end

	accessoryFrame:mouseFocused(focusedHandler)
	accessoryText:mouseFocused(focusedHandler)
	inputGrid:mouseFocused(focusedHandler)
	
	accessoryFrame:mouseUnfocused(unfocusedHandler)
	accessoryText:mouseUnfocused(unfocusedHandler)
	inputGrid:mouseUnfocused(unfocusedHandler)


	local x = 90
	for i,v in ipairs(tools[id].data.axis) do 
		local lbl = engine.guiTextBox()
		lbl.size = guiCoord(0, 13, 1, -6)
		lbl.position = guiCoord(0, x, 0, 3)
		lbl.guiStyle = enums.guiStyle.noBackground
		lbl.fontSize = 20
		lbl.fontFile = theme.font
		lbl.text = string.upper(v[1])
		lbl.readOnly = true
		lbl.align = enums.align.middleLeft
		lbl.parent = accessoryFrame
		lbl.textColour = theme.mainTxt
		lbl.alpha = 0.8

		local boolProp = engine.guiButton()
		boolProp.name = "bool"
		boolProp.parent = accessoryFrame
		boolProp.position = guiCoord(0,x+12,0.5,-8)
		boolProp.size = guiCoord(0, 20, 0, 20)
		boolProp.text = ""
		boolProp.guiStyle = enums.guiStyle.checkBox
		boolProp.selected = v[2]

		boolProp:mouseLeftReleased(function()
			tools[id].data.axis[i][2] = not tools[id].data.axis[i][2]
			boolProp.selected = tools[id].data.axis[i][2]
		end)


		lbl:mouseFocused(focusedHandler)
		boolProp:mouseFocused(focusedHandler)
		lbl:mouseUnfocused(unfocusedHandler)
		boolProp:mouseUnfocused(unfocusedHandler)
		x = x + 42
	end

	local isDown = false

	engine.tween:begin(accessoryFrame, .5, {position = guiCoord(0, 252, 0, 15)}, "inOutBack")


	local updateHandles;
	-- Store event handler so we can disconnect it later.

	local gridGuideline = engine.block("_CreateMode_")
	tools[id].data.gridGuideline = gridGuideline
	gridGuideline.size = vector3(0,0,0)
	gridGuideline.colour = colour(1, 1, 1)
	gridGuideline.parent = workspace
	gridGuideline.opacity = 0
	gridGuideline.workshopLocked = true
	gridGuideline.castsShadows = false

	tools[id].data.handles = {}
	local components = {"x", "y", "z"}
	local c = 1
	local o = 0
	for i = 1,6 do
		local componentIndex = c
		local component = components[c]
		local face = vector3(0,0,0)
		face[component] = o == 0 and o-1 or o

		local handle = engine.block("_CreateMode_")
		handle.castsShadows = false
		handle.opacity = 0
		handle.size = vector3(0.1,0.1,0.1)
		handle.colour = colour(c==1 and 1 or 0, c==2 and 1 or 0, c==3 and 1 or 0)
		handle.emissiveColour = colour(c==1 and .5 or 0, c==2 and .5 or 0, c==3 and .5 or 0)

		handle.workshopLocked = true

		handle:mouseLeftPressed(function()
			disableDefaultClickActions = true
			gridGuideline.size = vector3(300, 0.1, 300)
			gridGuideline.rotation = handle.rotation
			gridGuideline.position = handle.position
			if component == "x" then
				gridGuideline.rotation =  gridGuideline.rotation * quaternion():setEuler(math.rad(-45),math.rad(-45),0)
			end

			local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
			if not mouseHit or not mouseHit.object == gridGuideline then
				return print("Error, couldn't cast ray to guideline.")
			end

			local startSizes = {}
			local totalSize, totalposition = calculateBounding(selectedItems)

			for _,v in pairs(selectedItems) do
				startSizes[v] = {v.size, (v.position - totalposition)/totalSize,  v.size/totalSize}
			end

			local lastHit = mouseHit.hitPosition
			local firstHit = lastHit[component]

			local gridStep = tonumber(inputGrid.text)
			if not gridStep then gridStep = 0 else gridStep = math.abs(gridStep) end
			inputGrid.text = tostring(gridStep)
			repeat 
				if activeTool == id then
					--Face camera on one Axis
					gridGuideline.position = handle.position
					if component == "x" then
						local xVector1 = vector3(0, gridGuideline.position.y,gridGuideline.position.z)
						local xVector2 = vector3(0, workspace.camera.position.y, workspace.camera.position.z)

						local lookAt = gridGuideline.rotation:setLookRotation( xVector1 - xVector2 )
						gridGuideline.rotation =  lookAt * quaternion():setEuler(math.rad(45),0,0)
					else
						local pos1 = gridGuideline.position
						pos1[component] = 0

						local pos2 = workspace.camera.position
						pos2[component] = 0

						local lookAt = gridGuideline.rotation:setLookRotation( pos1 - pos2 )
						gridGuideline.rotation =  lookAt * quaternion():setEuler(math.rad(45),0,0)
					end

					local mouseHits = engine.physics:rayTestScreenAllHits( engine.input.mousePosition )
					local mouseHit = nil
					-- We only want the gridGuideline
					for _,hit in pairs(mouseHits) do
						if hit.object == gridGuideline then
							mouseHit = hit
							goto skip_loop
						end
					end
					::skip_loop::

					if mouseHit and mouseHit.object == gridGuideline and lastHit ~= mouseHit.hitPosition then
						local target = mouseHit.hitPosition
						lastHit = target

							local offsetVec = vector3(0,0,0)
							offsetVec[component] = target[component] - firstHit

							offsetVec  = offsetVec * face

							
print(offsetVec)
							local newSize = totalSize + (offsetVec)

							local size = totalSize:clone()
							if gridStep > 0 and tools[id].data.axis[componentIndex] then
								size[component] = roundToMultiple(newSize[component], gridStep)
							else
								size[component] = newSize[component]
							end

							local newPos = totalposition:clone()
						    newPos = newPos + (offsetVec /2) *face

					
						for _,v in pairs(selectedItems) do
							if startSizes[v] then
								local sizeRatio = startSizes[v][3]
								local offsetPos = startSizes[v][2] 
								local positionCalc = (offsetPos * newSize)
						
							    --offsetPos = offsetPos (size-totalSize)
								--v.position = pos
								engine.tween:begin(v, .05, {size = size*startSizes[v][3], position = newPos + positionCalc}, "inOutQuad")
							end
						end
					end
				end
				wait()
			until not engine.input:isMouseButtonDown(enums.mouseButton.left) or not activeTool == id
	
			delay(function() disableDefaultClickActions = false end, 1)
			if activeTool == id then
				gridGuideline.size = vector3(0,0,0)
			end
		end)
		
		table.insert(tools[id].data.handles, {handle, face})
		if i % 2 == 0 then
			c=c+1
			o = 0
		else
			o = o + 1
		end
	end

	updateHandles = function()
		if boundingBox.size == vector3(0,0,0) then
			for _,v in pairs(tools[id].data.handles) do
				v[1].size = vector3(0,0,0)
				v[1].opacity = 0
			end
		else
			for _,v in pairs(tools[id].data.handles) do
				v[1].position = boundingBox.position + boundingBox.rotation* ((v[2] * boundingBox.size/2) + (v[2]*1.5)) 
				v[1].size = vector3(0.25, 0.25, 0.25)
				v[1].opacity = 1
			end
		end
	end

	tools[id].data.keyDownEvent = engine.input:keyPressed(function ( inp )
		if inp.key == enums.key.t then
			inputGrid.text = "0"
		end
	end)

	tools[id].data.boundingEvent = boundingBox:changed(updateHandles)
	updateHandles()
end,
function (id)
	--deactivated
	local f = tools[id].data.accessoryFrame
	moveGrid = tostring(tonumber(f.inputGrid.text))

	if moveGrid == "nil" then moveGrid = "10" end
	engine.tween:begin(f, .3, {position = guiCoord(0, 252, 0, -40)}, "inOutBack", function()
		f:destroy()
	end)

	tools[id].data.keyDownEvent:disconnect()
	tools[id].data.keyDownEvent = nil

	tools[id].data.boundingEvent:disconnect()
	tools[id].data.boundingEvent = nil

	tools[id].data.accessoryFrame = nil

	for _,v in pairs(tools[id].data.handles) do
		v[1]:destroy()
	end
	tools[id].data.gridGuideline:destroy()
	tools[id].data.gridGuideline = nil
	tools[id].data.handles = nil

end, {world=false, axis={{"x", true},{"y", true},{"z", true}}})

-- End Tool


