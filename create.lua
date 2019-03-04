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

local function calculateBoundingBox()

	if #selectedItems < 1 then
		boundingBox.size = vector3(0,0,0)
		boundingBox.opacity = 0
	return end

	boundingBox.opacity = 0.5

	local min, max;

	for _,v in pairs(selectedItems) do
		if not min then min = v.position; max=v.position end
		local vertices = calculateVertices(v)
		for i,v in pairs(vertices) do
			min = min:min(v)
			max = max:max(v)
		end
	end

	boundingBox.size = max-min
	boundingBox.position = max - (max-min)/2
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
		calculateBoundingBox()
	else
		for i,v in pairs(selectedItems) do
			if v == mouseHit.object then
				table.remove(selectedItems, i)
				v.emissiveColour = colour(0.0, 0.0, 0.0)
				doSelect = false
			end
		end
	end

	if doSelect then

		mouseHit.object.emissiveColour = colour(0.025, 0.025, 0.15)

		table.insert(selectedItems, mouseHit.object)
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

local mainFrame = engine.guiFrame()
mainFrame.size = guiCoord(0, 132, 0, 36)
mainFrame.parent = engine.workshop.interface
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
logFrame.parent = engine.workshop.interface
logFrame.position = guiCoord(0, 0, 1, 0)
logFrame.backgroundColour = theme.mainBg
logFrame.alpha = 0.98
logFrame.visible = false

local logFrameTextBox = engine.guiTextBox()
logFrameTextBox.size = guiCoord(1, -4, 1, -26)
logFrameTextBox.position = guiCoord(0, 2, 0, 0)
logFrameTextBox.guiStyle = enums.guiStyle.noBackground
logFrameTextBox.fontSize = 9
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
codeInputBox.fontSize = 8
codeInputBox.fontFile = theme.font
codeInputBox.text = " "
codeInputBox.readOnly = false
codeInputBox.wrap = true
codeInputBox.multiline = false
codeInputBox.align = enums.align.middleLeft

--Create mode
local createModeFrame = engine.guiFrame()
createModeFrame.size = guiCoord(0, 85, 0, 36)
createModeFrame.parent = engine.workshop.interface
createModeFrame.position = guiCoord(0, 157, 0, -40)
createModeFrame.backgroundColour = theme.mainBg
createModeFrame.alpha = 0.985
createModeFrame.guiStyle = enums.guiStyle.rounded

local createModeText = engine.guiTextBox()
createModeText.size = guiCoord(1, -10, 1, -6)
createModeText.position = guiCoord(0, 10, 0, 3)
createModeText.guiStyle = enums.guiStyle.noBackground
createModeText.fontSize = 10
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
end, 1)
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
	elseif inputObj.key == enums.key.escape then
		for _,v in pairs(selectedItems) do
			v.emissiveColour = colour(0.0, 0.0, 0.0)
		end
		selectedItems = {}
		calculateBoundingBox()
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

-- End tool system


-- Tools

local moveGrid = "0" -- cache between tools.

-- Drag Tool
local toolBarDragBtn = addTool("local:hand.png", function(id)
	--activated

	--Accessory Frame
	local accessoryFrame = engine.guiFrame()
	accessoryFrame.size = guiCoord(0, 85, 0, 36)
	accessoryFrame.parent = engine.workshop.interface
	accessoryFrame.position = guiCoord(0, 252, 0, -40)
	accessoryFrame.backgroundColour = theme.mainBg
	accessoryFrame.alpha = 0.985
	accessoryFrame.guiStyle = enums.guiStyle.rounded

	tools[id].data.accessoryFrame = accessoryFrame

	local accessoryText = engine.guiTextBox()
	accessoryText.size = guiCoord(0, 40, 1, -6)
	accessoryText.position = guiCoord(0, 10, 0, 3)
	accessoryText.guiStyle = enums.guiStyle.noBackground
	accessoryText.fontSize = 10
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
	inputGrid.fontSize = 10
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
		lbl.fontSize = 10
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

	local roundToMultiple = function(number, multiple)
		if multiple == 0 then 
			return number 
		end

		return ((number % multiple) > multiple/2) and number + multiple - number%multiple or number - number%multiple
	end

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

			while isDown do
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
				calculateBoundingBox()
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
end, 1.3)



local toolBarMoveBtn = addTool("local:move.png", function(id)
	--activated

	--Accessory Frame
	local accessoryFrame = engine.guiFrame()
	accessoryFrame.size = guiCoord(0, 85, 0, 36)
	accessoryFrame.parent = engine.workshop.interface
	accessoryFrame.position = guiCoord(0, 252, 0, -40)
	accessoryFrame.backgroundColour = theme.mainBg
	accessoryFrame.alpha = 0.985
	accessoryFrame.guiStyle = enums.guiStyle.rounded

	tools[id].data.accessoryFrame = accessoryFrame

	local accessoryText = engine.guiTextBox()
	accessoryText.size = guiCoord(0, 40, 1, -6)
	accessoryText.position = guiCoord(0, 10, 0, 3)
	accessoryText.guiStyle = enums.guiStyle.noBackground
	accessoryText.fontSize = 10
	accessoryText.fontFile = theme.font
	accessoryText.text = "Grid:"
	accessoryText.readOnly = true
	accessoryText.align = enums.align.middleLeft
	accessoryText.parent = accessoryFrame
	accessoryText.textColour = theme.mainTxt
	accessoryText.alpha = 0.8

	local inputGrid = engine.guiTextBox()
	inputGrid.size = guiCoord(0, 38, 1, -8)
	inputGrid.position = guiCoord(0, 42, 0, 4)
	inputGrid.backgroundColour = theme.secondaryBg
	inputGrid.guiStyle = enums.guiStyle.rounded
	inputGrid.fontSize = 10
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
		lbl.fontSize = 10
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

	-- Store event handler so we can disconnect it later.

	local gridGuideline = engine.block("_CreateMode_")
	tools[id].data.gridGuideline = gridGuideline
	gridGuideline.size = vector3(0,0,0)
	gridGuideline.colour = colour(1, 1, 1)
	gridGuideline.parent = workspace
	gridGuideline.workshopLocked = true

	tools[id].data.handles = {}
	local components = {"x", "y", "z"}
	local c = 1
	local o = 0
	for i = 1,6 do
		local component = components[c]

		local handle = engine.block("_CreateMode_")
		handle.size = vector3(0.1, 0.1, 0.25)
		handle.colour = colour(c==1 and 1 or 0, c==2 and 1 or 0, c==3 and 1 or 0)
		handle.emissiveColour = colour(c==1 and .5 or 0, c==2 and .5 or 0, c==3 and .5 or 0)
		--handle.static = true
		handle.workshopLocked = true

		handle:mouseLeftPressed(function()
	
			local size = vector3(10, 0.1, 10)
			gridGuideline.size = size
			gridGuideline.rotation = handle.rotation
			gridGuideline.position = handle.position
			if component == "x" then
				print("comp x")
				gridGuideline.rotation =  gridGuideline.rotation * quaternion():setEuler(math.rad(-45),math.rad(-45),0)
			end

			repeat 
				--Face camera on one Axis
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

				wait()
			until not engine.input:isMouseButtonDown(enums.mouseButton.left)

			gridGuideline.size = vector3(0,0,0)
		end)


		local face = vector3(0,0,0)
		face[component] = o == 0 and o-1 or o
		
		table.insert(tools[id].data.handles, {handle, face})
		if i % 2 == 0 then
			c=c+1
			o = 0
		else
			o = o + 1
		end
	end

	local function updateHandles()
		if boundingBox.size == vector3(0,0,0) then
			for _,v in pairs(tools[id].data.handles) do
				v[1].size = vector3(0,0,0)
			end
		else
			for _,v in pairs(tools[id].data.handles) do
				v[1].position = boundingBox.position + boundingBox.rotation* (v[2] * boundingBox.size/2 * vector3(3,3,3)) 
				v[1]:lookAt(boundingBox.position)
				v[1].size = vector3(0.1, 0.1, 0.25)
			end
		end
	end

	tools[id].data.boundingEvent = boundingBox:changed(updateHandles)
	updateHandles()
end,
function (id)
	--deactivated
	local f = tools[id].data.accessoryFrame

	engine.tween:begin(f, .3, {position = guiCoord(0, 252, 0, -40)}, "inOutBack", function()
		f:destroy()
	end)

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



local toolBarRotateBtn = addTool("local:rotate.png")

local toolBarScaleBtn = addTool("local:scale.png")
-- End Tool