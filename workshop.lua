 -- Copyright (c) 2018 teverse.com
 -- workshop.lua

 -- This script has access to 'engine.workshop' APIs.
 -- Contains everything needed to grow your own workshop.

--
-- Undo/Redo History system
-- 

local history = {}
local dirty = {} -- Records changes made since last action
local currentPoint = 0 -- The current point in the history array that is used to undo
local goingBack = false -- Used to prevent objectChanged from functioning while undoing

local function objectChanged(property, value)
	-- TODO: self is a reference to an event object
	-- self.object is what the event is about
	-- self:disconnect() is used to disconnect this handler
	if goingBack then return end 
	
	if not dirty[self.object] then 
		dirty[self.object] = {}
	end

	if not dirty[self.object][property] then
		-- mark the property as changed  
		dirty[self.object][property] = self.object[property]
	end
end

local function savePoint()
	local newPoint = {}
	
	for object, properties in pairs(dirty) do
		newPoint[object] = properties
	end
	
	if currentPoint < #history then
		-- the user just undoed
		-- lets overwrite the no longer history
		local historySize = #history
		for i = currentpoint+1, historySize do
			table.remove(history, i)
		end
	end
	
	table.insert(history, newPoint)
	currentPoint = #history
	dirty = {}
end

-- hook existing objects
for _,v in pairs(workspace.children) do
	v:changed(objectChanged)
end

workspace:childAdded(function(child)
	child:changed(objectChanged)
	if not goingBack and dirty[child] then
		dirty[child].new = true
	end
end)

function undo()
	if currentPoint == 0 then return end
	
	currentPoint = currentPoint - 1
	local snapShot = history[currentPoint] 
	if not snapShot then snapShot = {} end

	goingBack = true
	
	for object, properties in pairs(snapShot) do
		for property, value in pairs(properties) do
			object[property] = value
		end
	end
	
	goingBack = false
end

function redo()
	if currentPoint >= #history then
		return print("Debug: can't redo.")
	end

	currentPoint = currentPoint + 1
	local snapShot = history[currentPoint] 
	if not snapShot then return print("Debug: no snapshot found") end

	goingBack = true
	
	for object, properties in pairs(snapShot) do
		for property, value in pairs(properties) do
			object[property] = value
		end
	end
	
	goingBack = false
end

-- 
-- UI
--

local normalFontName = "OpenSans-Regular"
local boldFontName = "OpenSans-Bold"
 
-- Menu Bar Creation

local menuBarTop = engine.guiMenuBar()
menuBarTop.size = guiCoord(1, 0, 0, 24)
menuBarTop.position = guiCoord(0, 0, 0, 0)
menuBarTop.parent = engine.workshop.interface

-- File Menu

local menuFile = menuBarTop:createItem("File")

local menuFileNew = menuFile:createItem("New Scene")
local menuFileOpen = menuFile:createItem("Open Scene")
local menuFileSave = menuFile:createItem("Save Scene")
local menuFileSaveAs = menuFile:createItem("Save Scene As")

-- Edit Menu

local menuEdit = menuBarTop:createItem("Edit")
local menuEditUndo = menuEdit:createItem("Undo")
local menuEditRedo = menuEdit:createItem("Redo")

-- Insert Menu

local menuInsert = menuBarTop:createItem("Insert")
local menuInsertBlock = menuInsert:createItem("Block")

menuEditUndo:mouseLeftPressed(undo)
menuEditRedo:mouseLeftPressed(redo)

menuFileNew:mouseLeftPressed(function()
	engine.workshop:newGame()
end)

menuFileOpen:mouseLeftPressed(function()
	-- Tell the Workshop APIs to initate a game load.
	engine.workshop:openFileDialogue()
end)

menuFileSave:mouseLeftPressed(function()
	engine.workshop:saveGame() -- returns boolean
end)

menuFileSaveAs:mouseLeftPressed(function()
	engine.workshop:saveGameAsDialogue()
end)

menuInsertBlock:mouseLeftPressed(function ()
	local newBlock = engine.block("block")
	newBlock.colour = colour(1,0,0)
	newBlock.size = vector3(1,1,1)
	newBlock.parent = workspace

	local camera = workspace.camera
		
	local lookVector = camera.rotation * vector3(0, 0, 1)
	newBlock.position = camera.position - (lookVector * 10)

	savePoint() -- for undo/redo
end)

local windowProperties = engine.guiWindow()
windowProperties.size = guiCoord(0, 240, 0.5, -12)
windowProperties.position = guiCoord(1, -245, 0, 24)
windowProperties.parent = engine.workshop.interface
windowProperties.text = "Properties"
windowProperties.fontSize = 10
windowProperties.backgroundColour = colour(1/20, 1/20, 1/20)
windowProperties.fontFile = normalFontName

local scrollViewProperties = engine.guiScrollView("scrollView")
scrollViewProperties.size = guiCoord(1,-5,1,-20)
scrollViewProperties.parent = windowProperties
scrollViewProperties.position = guiCoord(0,0,0,15)
scrollViewProperties.guiStyle = enums.guiStyle.noBackground


local function generateLabel(text, parent)
	local lbl = engine.guiTextBox()
	lbl.size = guiCoord(1, 0, 0, 16)
	lbl.position = guiCoord(0, 0, 0, 0)
	lbl.fontSize = 9
	lbl.guiStyle = enums.guiStyle.noBackground
	lbl.fontFile = normalFontName
	lbl.text = tostring(text)
	lbl.wrap = false
	lbl.align = enums.align.middleLeft
	lbl.parent = parent or engine.workshop.interface
	lbl.textColour = colour(1, 1, 1)

	return lbl
end

local function setReadOnly( textbox, value )
	textbox.readOnly = value
	if value then
		textbox.alpha = 0.3
	else
		textbox.alpha = 1
	end
end


local function generateInputBox(text, parent)
	local lbl = engine.guiTextBox()
	lbl.size = guiCoord(1, 0, 0, 21)
	lbl.position = guiCoord(0, 0, 0, 0)
	lbl.backgroundColour = colour(8/255, 8/255, 11/255)
	lbl.fontSize = 9
	lbl.fontFile = normalFontName
	lbl.text = tostring(text)
	lbl.readOnly = false
	lbl.wrap = true
	lbl.multiline = false
	lbl.align = enums.align.middle
	if parent then
		lbl.parent = parent
	end
	lbl.textColour = colour(1, 1, 1)

	return lbl
end

-- Selected Integer Text

local txtProperty = generateLabel("0 items selected", windowProperties)
txtProperty.name = "txtProperty"
txtProperty.textColour = colour(1,0,0)

local event = nil -- stores the instance changed event so we can disconnect it

local function generateProperties( instance )

	if event then
		event:disconnect()
		event = nil
	end

	for _,v in pairs(scrollViewProperties.children) do
		if v.name ~= "txtProperty" then

			v:destroy()

		end
	end
	if not instance then 
		scrollViewProperties.canvasSize = guiCoord(1,0,1,0)
	return end

	event = instance:changed(function(key,value,oldValue)
		for _,v in pairs(scrollViewProperties.children) do
			if v.name == key then
				local propertyType = type(value)
				if propertyType == "vector2" then

					v.x.text = tostring(value.x)
					v.y.text = tostring(value.y)

				elseif propertyType == "colour" then

					v.r.text = tostring(value.r)
					v.g.text = tostring(value.g)
					v.b.text = tostring(value.b)

				elseif propertyType == "vector3" then

					v.x.text = tostring(value.x)
					v.y.text = tostring(value.y)
					v.z.text = tostring(value.z)

				elseif propertyType == "guiCoord" then

					v.scaleX.text = tostring(value.scaleX)
					v.scaleY.text = tostring(value.scaleY)
					v.offsetX.text = tostring(value.offsetX)
					v.offsetY.text = tostring(value.offsetY)

				elseif propertyType == "boolean" then

					v.bool.selected = value

				elseif isInstance(value) then
					
				elseif propertyType == "number" then
					v.number.text = tostring(value)
				else
					v.input.text = tostring(value)
				end
			end
		end
	end)

	local members = engine.workshop:getMembersOfInstance( instance )

	local y = 0

	table.sort( members, function( a,b ) return a.property < b.property end ) -- alphabetical sort


 	for i, prop in pairs (members) do

		local value = instance[prop.property]
		local propertyType = type(value)
		local readOnly = not prop.writable

		if propertyType == "function" or propertyType == "table" or propertyType == "quaternion" then
			-- Lua doesn't come with a "continue"
			-- Teverse uses LuaJIT,
			-- Here's a fancy functionality:
			-- Jumps to the ::continue:: label
			goto continue 
		end

		local lblProp = generateLabel(prop.property, scrollViewProperties)
		lblProp.position = guiCoord(0,3,0,y)
		lblProp.size = guiCoord(0.47, -6, 0, 15)
		lblProp.name = "Property" 

		if readOnly then
			lblProp.alpha = 0.5
		end
		
		local propContainer = engine.guiFrame() 
		propContainer.parent = scrollViewProperties
		propContainer.name = prop.property
		propContainer.size = guiCoord(0.54, -9, 0, 21) -- Compensates for the natural padding inside a guiWindow.
		propContainer.position = guiCoord(0.45,0,0,y)
		propContainer.alpha = 0

		if propertyType == "vector2" then

			local txtProp = generateInputBox(value.x, propContainer)
			txtProp.name = "x"
			txtProp.position = guiCoord(0,0,0,0)
			txtProp.size = guiCoord(0.5, -1, 1, 0)
			setReadOnly(txtProp, readOnly)

			local txtProp = generateInputBox(value.y, propContainer)
			txtProp.name = "y"
			txtProp.position = guiCoord(0.5,2,0,0)
			txtProp.size = guiCoord(0.5, -1, 1, 0)
			setReadOnly(txtProp, readOnly)

		elseif propertyType == "colour" then

			local colourPreview = engine.guiFrame() 
			colourPreview.name = "preview"
			colourPreview.parent = propContainer
			colourPreview.size = guiCoord(0.25, -10, 1, -12)
			colourPreview.position = guiCoord(0.75, 7, 0, 6)
			colourPreview.backgroundColour = value

			local txtR = generateInputBox(value.r, propContainer)
			txtR.name = "r"
			txtR.position = guiCoord(0,0,0,0)
			txtR.size = guiCoord(0.25, -1, 1, 0)
			setReadOnly(txtR, readOnly)

			txtR:textInput(function(value) -- Only fires when a user types in the box.
					local col = instance[prop.property]
					col.r = tonumber(value)
					instance[prop.property] = col
					colourPreview.backgroundColour = col
			end)

			local txtG = generateInputBox(value.g, propContainer)
			txtG.name = "g"
			txtG.position = guiCoord(0.25,1,0,0)
			txtG.size = guiCoord(0.25, -1, 1, 0)
			setReadOnly(txtG, readOnly)

			txtG:textInput(function(value) -- Only fires when a user types in the box.
					local col = instance[prop.property]
					col.g = tonumber(value)
					instance[prop.property] = col
					colourPreview.backgroundColour = col				
			end)

			local txtB = generateInputBox(value.b, propContainer)
			txtB.name = "b"
			txtB.position = guiCoord(0.5,2,0,0)
			txtB.size = guiCoord(0.25, -1, 1, 0)
			setReadOnly(txtB, readOnly)

			txtB:textInput(function(value) -- Only fires when a user types in the box.
					local col = instance[prop.property]
					col.b = tonumber(value)
					instance[prop.property] = col
					colourPreview.backgroundColour = col
			end)

		elseif propertyType == "vector3" then

			local txtX = generateInputBox(value.x, propContainer)
			txtX.position = guiCoord(0,0,0,0)
			txtX.name = "x"
			txtX.size = guiCoord(1/3, -1, 1, 0)
			setReadOnly(txtX, readOnly)

			txtX:textInput(function(value) -- Only fires when a user types in the box.
					local vec = instance[prop.property]
					vec.x = tonumber(value)
					instance[prop.property] = vec
			end)


			local txtY = generateInputBox(value.y, propContainer)
			txtY.name = "y"
			txtY.position = guiCoord(1/3,1,0,0)
			txtY.size = guiCoord(1/3, -1, 1, 0)
			setReadOnly(txtY, readOnly)

			txtY:textInput(function(value) -- Only fires when a user types in the box.
					local vec = instance[prop.property]
					vec.y = tonumber(value)
					instance[prop.property] = vec
			end)

			local txtZ = generateInputBox(value.z, propContainer)
			txtZ.name = "z"
			txtZ.position = guiCoord(2/3,2,0,0)
			txtZ.size = guiCoord(1/3, -1, 1, 0)
			setReadOnly(txtZ, readOnly)

			txtZ:textInput(function(value) -- Only fires when a user types in the box.
					local vec = instance[prop.property]
					vec.z = tonumber(value)
					instance[prop.property] = vec
			end)


		elseif propertyType == "guiCoord" then

			local scaleX = generateInputBox(value.scaleX, propContainer)
			scaleX.name = "scaleX"
			scaleX.position = guiCoord(0,0,0,0)
			scaleX.size = guiCoord(0.25, -1, 1, 0)
			setReadOnly(scaleX, readOnly)

			scaleX:textInput(function(value) -- Only fires when a user types in the box.
					local coord = instance[prop.property]
					coord.scaleX = tonumber(value)
					instance[prop.property] = coord
			end)

			local offsetX = generateInputBox(value.offsetX, propContainer)
			offsetX.name = "offsetX"
			offsetX.position = guiCoord(0.25,1,0,0)
			offsetX.size = guiCoord(0.25, -1, 1, 0)
			setReadOnly(offsetX, readOnly)

			offsetX:textInput(function(value) -- Only fires when a user types in the box.
					local coord = instance[prop.property]
					coord.offsetX = tonumber(value)
					instance[prop.property] = coord
			end)

			local scaleY = generateInputBox(value.scaleY, propContainer)
			scaleY.name = "scaleY"
			scaleY.position = guiCoord(0.5,2,0,0)
			scaleY.size = guiCoord(0.25, -1, 1, 0)
			setReadOnly(scaleY, readOnly)

			scaleY:textInput(function(value) -- Only fires when a user types in the box.
					local coord = instance[prop.property]
					coord.scaleY = tonumber(value)
					instance[prop.property] = coord
			end)

			local offsetY = generateInputBox(value.offsetY, propContainer)
			offsetY.name = "offsetY"
			offsetY.position = guiCoord(0.75,2,0,0)
			offsetY.size = guiCoord(0.25, -1, 1, 0)
			setReadOnly(offsetY, readOnly)

			offsetY:textInput(function(value) -- Only fires when a user types in the box.
					local coord = instance[prop.property]
					coord.offsetY = tonumber(value)
					instance[prop.property] = coord
			end)

		elseif propertyType == "boolean" then

			local boolProp = engine.guiButton()
			boolProp.name = "bool"
			boolProp.parent = propContainer
			boolProp.position = guiCoord(0,0,0,2)
			boolProp.size = guiCoord(1, 0, 1, 0)
			boolProp.text = ""
			boolProp.guiStyle = enums.guiStyle.checkBox
			boolProp.selected = value

			boolProp:mouseLeftPressed(function()
				boolProp.selected = not boolProp.selected
				instance[prop.property] = boolProp.selected
			end)

		elseif isInstance(value) then
			--TODO: Allow user to select instance using explorer...
			local placeholder = generateLabel(" . " .. propertyType .. " . ", propContainer)
			placeholder.position = guiCoord(0,0,0,0)
			placeholder.size = guiCoord(1, 0, 1, 0)
			placeholder.align = enums.align.middle
			placeholder.alpha = 0.6
		elseif propertyType == "number" then

			local txtProp = generateInputBox(value, propContainer)
			txtProp.name = "number"
			txtProp.position = guiCoord(0,1,0,0)
			txtProp.size = guiCoord(1, 0, 1, 0)
			setReadOnly(txtProp, readOnly)

			txtProp:textInput(function(value) -- Only fires when a user types in the box.
					instance[prop.property] = tonumber(value)
			end)

		else
			local txtProp = generateInputBox(value, propContainer)
			txtProp.name = "input"
			txtProp.position = guiCoord(0,1,0,0)
			txtProp.size = guiCoord(1, 0, 1, 0)
			setReadOnly(txtProp, readOnly)

			txtProp:textInput(function(value) -- Only fires when a user types in the box.
					instance[prop.property] = value
			end)
		end

		y = y + 22

		::continue::
	end

	scrollViewProperties.canvasSize = guiCoord(1,0,0,y+40)
end
generateProperties(txtProperty)

-- 
-- Workshop Camera
-- Altered from https://wiki.teverse.com/tutorials/base-camera
--

-- The distance the camera is from the target
local target = vector3(0,0,0) -- A virtual point that the camera
local currentDistance = 20

-- The amount the camera moves when you use the scrollwheel
local zoomStep = 3
local rotateStep = -0.0045
local moveStep = 0.5 -- how fast the camera moves

local camera = workspace.camera

-- Setup the initial position of the camera
camera.position = target - vector3(0, -5, currentDistance)
camera:lookAt(target)

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

local function updatePosition()
	local lookVector = camera.rotation * vector3(0, 0, 1)
	
	camera.position = target + (lookVector * currentDistance)
	camera:lookAt(target)
end

engine.input:mouseScrolled(function( input )
	currentDistance = currentDistance - (input.movement.y * zoomStep)
	updatePosition()
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

savePoint() -- Create a point.

--
-- Selection System
--

--testing purposes
local newBlock = engine.block("block")
newBlock.colour = colour(1,0,0)
newBlock.size = vector3(1,10,1)
newBlock.position = vector3(0,0,0)
newBlock.parent = workspace
--testing purposes

-- This block is used to show an outline around things we're hovering.
local outlineHoverBlock = engine.block("workshopHoverOutlineWireframe")
outlineHoverBlock.wireframe = true
outlineHoverBlock.anchored = true
outlineHoverBlock.physics = false
outlineHoverBlock.colour = colour(1, 1, 0)
outlineHoverBlock.opacity = 0

-- This block is used to outline selected items
local outlineSelectedBlock = engine.block("workshopSelectedOutlineWireframe")
outlineSelectedBlock.wireframe = true
outlineSelectedBlock.anchored = true
outlineSelectedBlock.physics = false
outlineSelectedBlock.colour = colour(0, 1, 1)
outlineSelectedBlock.opacity = 0


local selectedItems = {}

engine.graphics:frameDrawn(function()	
	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition ) -- accepts vector2 or number,number
	if mouseHit then 
		outlineHoverBlock.size = mouseHit.size
		outlineHoverBlock.position = mouseHit.position
		outlineHoverBlock.opacity = 1
	else
		outlineHoverBlock.opacity = 0
	end
end)

engine.input:mouseLeftPressed(function( input )
	
	if input.systemHandled then return end

	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )

	if not mouseHit then
		-- User clicked empty space, deselect everything??
		selectedItems = {}
		outlineSelectedBlock.opacity = 0
		txtProperty.text = "0 items selected"
		generateProperties( nil )
		return
	end

	local doSelect = true

	if not engine.input:isKeyDown(enums.key.leftShift) then
		-- deselect everything and move on
		selectedItems = {}	
	else
		for i,v in pairs(selectedItems) do
			if v == mouseHit then
				-- deselect
				table.remove(selectedItems, i)
				doSelect = false
			end
		end
	end

	if doSelect then
		table.insert(selectedItems, mouseHit)
		generateProperties(mouseHit)
	end

	if #selectedItems > 1 then
		outlineSelectedBlock.opacity = 1
		
		-- used to calculate bounding box area...
		local upper = selectedItems[1].position + (selectedItems[1].size/2)
		local lower = selectedItems[1].position - (selectedItems[1].size/2)

		for i, v in pairs(selectedItems) do
			local topLeft = v.position + (v.size/2)
			local btmRight = v.position - (v.size/2)
		
			upper.x = math.max(topLeft.x, upper.x)
			upper.y = math.max(topLeft.y, upper.y)
			upper.z = math.max(topLeft.z, upper.z)

			lower.x = math.min(btmRight.x, lower.x)
			lower.y = math.min(btmRight.y, lower.y)
			lower.z = math.min(btmRight.z, lower.z)
		end

		outlineSelectedBlock.position = (upper+lower)/2
		outlineSelectedBlock.size = upper-lower
	elseif #selectedItems == 1 then
		outlineSelectedBlock.opacity = 1
		outlineSelectedBlock.position = selectedItems[1].position
		outlineSelectedBlock.size = selectedItems[1].size
	elseif #selectedItems == 0 then
		outlineSelectedBlock.opacity = 0
	end

	txtProperty.text = #selectedItems .. " item" .. (#selectedItems == 1 and "" or "s") .. " selected"
end)

