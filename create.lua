 -- Copyright (c) 2019 teverse.com
 -- create mode

 -- This script should get access to 'engine.workshop' APIs.

local darkTheme = {
	font = "OpenSans-Regular",
	fontBold = "OpenSans-Bold",

	mainBg  = colour:fromRGB(66, 66, 76),
	mainTxt = colour:fromRGB(255, 255, 255),

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

theme = lightTheme


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

local starterBlock = engine.block("block")
starterBlock.colour = colour(0,1,1)
starterBlock.size = vector3(1,1,1)
starterBlock.position = vector3(-22, 2, -22)
starterBlock.parent = workspace


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
end)

-- End Camera

-- Main GUI

local mainFrame = engine.guiFrame()
mainFrame.size = guiCoord(0, 250, 0, 36)
mainFrame.parent = engine.workshop.interface
mainFrame.position = guiCoord(0, 15, 0, 15)
mainFrame.backgroundColour = theme.mainBg
mainFrame.alpha = 0.985

local toolBarMain = engine.guiFrame()
toolBarMain.size = guiCoord(1, -6, 0, 30)
toolBarMain.position = guiCoord(0, 3, 0, 3)
toolBarMain.parent = mainFrame
toolBarMain.alpha = 0

local logFrame = engine.guiFrame()
logFrame.size = guiCoord(1, 0, 1, 220)
logFrame.parent = engine.workshop.interface
logFrame.position = guiCoord(0, 0, 1, 0)
logFrame.backgroundColour = theme.mainBg
logFrame.alpha = 0.985
logFrame.visible = false

local logFrameTextBox = engine.guiTextBox()
logFrameTextBox.size = guiCoord(1, -4, 1, 0)
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

-- Selection System

local selectedItems = {}

-- End Selection System

-- Tools
local toolBarDragBtn = addTool("local:hand.png", function(id)
	--activated
	print("Activated Hand")
	local isDown = false

	-- Store event handler so we can disconnect it later.
	tools[id].data.mouseDownEvent = engine.input:mouseLeftPressed(function ( inp )
		if inp.systemHandled then return end
		
		isDown = true
		
		if (#selectedItems > 0) then

			local hit = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, selectedItems)
			if #hit < 1 then return print("Cannot cast starter ray!") end

			wait(.2)
			if not isDown then return end -- they held the button down, so let's start drag
			disableDefaultClickActions = true

			hit = hit[1]
			print("Starter Position:", hit.hitPosition)
			clickMarker.position = hit.hitPosition
			print("Begin drag of " .. #selectedItems .. " items.")
			while isDown do

				wait()
			end
			print("End drag.")
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
	print("Deactivated Hand")
	tools[id].data.mouseDownEvent:disconnect()
	tools[id].data.mouseUpEvent:disconnect()

	tools[id].data.mouseDownEvent = nil
	tools[id].data.mouseUpEvent = nil
end)

activeTool = toolBarDragBtn.id
toolBarDragBtn.gui.imageColour = theme.toolSelected
toolBarDragBtn.activate(activeTool)

local toolBarMoveBtn = addTool("local:move.png")

local toolBarRotateBtn = addTool("local:rotate.png")

local toolBarScaleBtn = addTool("local:scale.png")
-- End Tools
