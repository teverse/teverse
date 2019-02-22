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

local starterBlock2 = engine.block("geren")
starterBlock2.colour = colour(0,1,0)
starterBlock2.size = vector3(0.8,1,0.2)
starterBlock2.position = vector3(-23, 2, -22)
starterBlock2.parent = workspace

local starterBlock3 = engine.block("blyue")
starterBlock3.colour = colour(0,0.2,1)
starterBlock3.size = vector3(1,0.5,1)
starterBlock3.position = vector3(-22.5, 2.75, -22)
starterBlock3.parent = workspace


-- Selection System

-- This block is used to show an outline around things we're hovering.
local outlineHoverBlock = engine.block("workshopHoverOutlineWireframe")
outlineHoverBlock.wireframe = true
outlineHoverBlock.static = true
outlineHoverBlock.physics = false
outlineHoverBlock.colour = colour(0, 1, 0)
outlineHoverBlock.size = vector3(0, 0, 0)
outlineHoverBlock.opacity = 0

engine.graphics:frameDrawn(function(events, frameNumber)	
	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition ) -- accepts vector2 or number,number

	if mouseHit and not disableDefaultClickActions and not mouseHit.object.workshopLocked then 
		outlineHoverBlock.size = mouseHit.object.size
		outlineHoverBlock.position = mouseHit.object.position
		outlineHoverBlock.rotation = mouseHit.object.rotation
		outlineHoverBlock.opacity = 1
	else
		outlineHoverBlock.opacity = 0
		outlineHoverBlock.size = vector3(0, 0, 0)
	end
end)


-- This block is used to outline selected items
local outlineSelectedBlock = engine.block("workshopSelectedOutlineWireframe")
outlineSelectedBlock.wireframe = true
outlineSelectedBlock.static = true
outlineSelectedBlock.physics = false
outlineSelectedBlock.colour = colour(1, 0, 0)
outlineSelectedBlock.size = vector3(0, 0, 0)
outlineSelectedBlock.opacity = 0

local selectedItems = {}

-- Clean out any deleted items.
local function validateItems()
	for i,v in pairs(selectedItems) do
		if not v or v.isDestroyed then 
			table.remove(selectedItems, i)
		end
	end
end


local function updateBounding(  )
	if #selectedItems > 1 then
		outlineSelectedBlock.opacity = 1
		local i =1
	
		-- used to calculate bounding box area...
		local upper = selectedItems[i].position + (selectedItems[i].size/2) or vector3(0.1, 0.1, 0.1)
		local lower = selectedItems[i].position - (selectedItems[i].size/2) or vector3(0.1, 0.1, 0.1)

		for i, v in pairs(selectedItems) do
			if type(v.size) == "vector3" and type(v.position) == "vector3" then
				local topLeft = v.position + (v.size/2)or vector3(0.1, 0.1, 0.1)
				local btmRight = v.position - (v.size/2)or vector3(0.1, 0.1, 0.1)
			
				upper.x = math.max(topLeft.x, upper.x)
				upper.y = math.max(topLeft.y, upper.y)
				upper.z = math.max(topLeft.z, upper.z)

				lower.x = math.min(btmRight.x, lower.x)
				lower.y = math.min(btmRight.y, lower.y)
				lower.z = math.min(btmRight.z, lower.z)
			end
		end

		outlineSelectedBlock.position = (upper+lower)/2
		outlineSelectedBlock.size = upper-lower
		
	elseif #selectedItems == 1 and selectedItems[1].className == "block" then
		outlineSelectedBlock.opacity = 1
		outlineSelectedBlock.position = selectedItems[1].position
		outlineSelectedBlock.size = selectedItems[1].size or vector3(0.1, 0.1, 0.1)
	elseif #selectedItems == 0 then
		outlineSelectedBlock.opacity = 0
		outlineSelectedBlock.size = vector3(0, 0, 0)
	end
end

engine.input:mouseLeftReleased(function( input )
	if input.systemHandled or disableDefaultClickActions then return end

	validateItems()

	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
	if not mouseHit or mouseHit.object.workshopLocked then
		-- User clicked empty space, deselect everything??#
		selectedItems = {}
		outlineSelectedBlock.opacity = 0
		updateBounding()
		return
	end

	local doSelect = true

	if not engine.input:isKeyDown(enums.key.leftShift) then
		-- deselect everything that's already selected and move on
		selectedItems = {}
	else
		for i,v in pairs(selectedItems) do
			if v == mouseHit.object then
				table.remove(selectedItems, i)
				doSelect = false
			end
		end
	end

	if doSelect then

		table.insert(selectedItems, mouseHit.object)
	end

	updateBounding()
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
logFrameTextBox.textColour = colour(1, 1, 1)

local codeInputBox = engine.guiTextBox()
codeInputBox.parent = logFrame
codeInputBox.size = guiCoord(1, 0, 0, 23)
codeInputBox.position = guiCoord(0, 0, 1, -25)
codeInputBox.backgroundColour = theme.secondaryBg
codeInputBox.fontSize = 8
codeInputBox.fontFile = theme.font
codeInputBox.text = " t"
codeInputBox.readOnly = false
codeInputBox.wrap = true
codeInputBox.multiline = false
codeInputBox.align = enums.align.middleLeft

delay(function()
	engine.tween:begin(mainFrame, .5, {position = guiCoord(0, 15, 0, 15)}, "inOutBack")
end, 1)

-- End Main Gui


-- Output System

local inAction = false
engine.input:keyPressed(function( inputObj )
	if inputObj.systemHandled or inAction then return end

	if inputObj.key == enums.key.escape then
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
			lbl:setText("")
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

local function addTool(image, activate, deactivate)
	local toolID = #tools + 1;

	local toolButton = engine.guiImage()
	toolButton.size = guiCoord(0, 24, 0, 24)
	toolButton.position = guiCoord(0, 5 + (30 * #tools), 0, 3)
	toolButton.parent = toolBarMain
	toolButton.guiStyle = enums.guiStyle.noBackground
	toolButton.imageColour = theme.toolDeselected
	toolButton.texture = image;

	toolButton:mouseLeftReleased(function()
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

	table.insert(tools, {["id"]=toolID, ["gui"]=toolButton, ["data"]={}, ["activate"] = activate, ["deactivate"] = deactivate})
	return tools[toolID]
end

-- End tool system


-- Tools
local toolBarDragBtn = addTool("local:hand.png", function(id)
	--activated
	local isDown = false
	local applyRot = 0

	local tweens = {}

	-- Store event handler so we can disconnect it later.
	tools[id].data.mouseDownEvent = engine.input:mouseLeftPressed(function ( inp )
		if inp.systemHandled then return end
	
		isDown = true
		applyRot = 0
		if (#selectedItems > 0) then

			local hit, didExclude = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, selectedItems)
			
			-- Didexclude is false if the user didnt drag starting from one of the selected items.
			if  didExclude == false then return print("Cannot cast starter ray!") end

			wait(.35)
			if not isDown then return end -- they held the button down, so let's start dragging
			print("Start drag.")
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

						updateBounding()
					end
				end
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
	end)

	tools[id].data.mouseUpEvent = engine.input:mouseLeftReleased(function ( inp )
		if inp.systemHandled then return end
		isDown = false
		wait(0.2)
		if not isDown and activeTool == id then
			disableDefaultClickActions = false
		end
	end)

end,
function (id)
	--deactivated


	tools[id].data.mouseDownEvent:disconnect()
	tools[id].data.mouseUpEvent:disconnect()
	tools[id].data.keyDownEvent:disconnect()

	tools[id].data.mouseDownEvent = nil
	tools[id].data.mouseUpEvent = nil
	tools[id].data.keyDownEvent = nil
end)

activeTool = toolBarDragBtn.id
toolBarDragBtn.gui.imageColour = theme.toolSelected
toolBarDragBtn.activate(activeTool)

local toolBarMoveBtn = addTool("local:move.png")

local toolBarRotateBtn = addTool("local:rotate.png")

local toolBarScaleBtn = addTool("local:scale.png")
-- End Tool