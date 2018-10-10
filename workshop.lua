 -- Copyright (c) 2018 teverse.com
 -- workshop.lua

 -- This script has access to 'engine.workshop' APIs.
 -- Contains everything needed to grow your own workshop.

--
-- Undo/Redo History system
-- 

local history = {}
local dirty = {} -- record things that have changed since last action
local currentPoint = 0 -- the current point in history used to undo 
local goingBack = false

local function objectChanged(property)
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
		--local thisObject = {}
		--for property, oldValue in pairs(properties) do
		--	table.insert(thi
		--end
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
	if currentpoint >= #history then
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

local menuBarTop = engine.guiMenuBar()
menuBarTop.size = guiCoord(1, 0, 0, 24)
menuBarTop.position = guiCoord(0, 0, 0, 0)
menuBarTop.parent = engine.workshop.interface

local menuFile = menuBarTop:createItem("File")
local menuFileNew = menuFile:createItem("New Scene")
local menuFileOpen = menuFile:createItem("Open Scene")
local menuFileSave = menuFile:createItem("Save Scene")
local menuFileSaveAs = menuFile:createItem("Save Scene As")

local menuEdit = menuBarTop:createItem("Edit")
local menuEditUndo = menuEdit:createItem("Undo")
local menuEditRedo = menuEdit:createItem("Redo")

local menuInsert = menuBarTop:createItem("Insert")
local menuInsertBlock = menuInsert:createItem("Block")

-- Define events to handle undo/redo button clicks
menuEditUndo:mouseLeftPressed(undo)
menuEditRedo:mouseLeftPressed(redo)

-- Define place loading events
menuFileOpen:mouseLeftPressed(function()
	-- Tell the Workshop APIs to initate a game load.
	engine.workshop:openFileDialogue()
end)

menuFileNew:mouseLeftPressed(function()
	engine.workshop:newGame()
end)

menuFileOpen:mouseLeftPressed(function()
	engine.workshop:saveGame() -- returns boolean
end)

menuFileOpen:mouseLeftPressed(function()
	engine.workshop:saveGameAsDialogue()
end)



-- Block creation function. Creates a new block and positions it relative to the user's camera
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
windowProperties.size = guiCoord(0, 220, 0.5, -12)
windowProperties.position = guiCoord(1, -220, 0, 24)
windowProperties.parent = engine.workshop.interface

-- 
-- Workshop camera
-- Currently modified from the Wiki Tutorial
--

-- The distance the camera is from the target
local target = vector3(0,0,0) -- A virtual point that the camera
local currentDistance = 20

-- The amount the camera moves when you use the scrollwheel
local zoomStep     = 3
local rotateStep   = -0.0045
local moveStep     = 0.5 -- how fast the camera moves

local camera = workspace.camera

-- Setup the initial position of the camera
camera.position = target - vector3(0, -5, currentDistance)
camera:lookAt(target)

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


local cameraKeyEventLooping = false

-- These key events trigger a loop that will continuously move the camera until all keys are released.
engine.input:keyPressed(function( inputObj )

    if inputObj.key == enums.key.w or
       inputObj.key == enums.key.a or
       inputObj.key == enums.key.s or
       inputObj.key == enums.key.d or
       inputObj.key == enums.key.q or
       inputObj.key == enums.key.e and 
       not cameraKeyEventLooping then

    	cameraKeyEventLooping = true

    	repeat
			local cameraPos = camera.position
			if engine.input:isKeyDown(enums.key.w) then
				cameraPos = cameraPos - (camera.rotation * vector3(0, 0, 1) * moveStep)
			elseif engine.input:isKeyDown(enums.key.s) then
				cameraPos = cameraPos + (camera.rotation * vector3(0, 0, 1) * moveStep)
			elseif engine.input:isKeyDown(enums.key.a) then
				cameraPos = cameraPos - (camera.rotation * vector3(1, 0, 0) * moveStep)
			elseif engine.input:isKeyDown(enums.key.d) then
				cameraPos = cameraPos + (camera.rotation * vector3(1, 0, 0) * moveStep)
			elseif engine.input:isKeyDown(enums.key.q) then
				cameraPos = cameraPos - (camera.rotation * vector3(0, 1, 0) * moveStep)
			elseif engine.input:isKeyDown(enums.key.e) then
				cameraPos = cameraPos + (camera.rotation * vector3(0, 1, 0) * moveStep)
			end

			cameraKeyEventLooping = (cameraPos ~= camera.position) -- If there's no keys down, stop the loop!
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
local redraw = true -- a way to stop updating the selection box when nothing has happened.

--WIP
engine.graphics:frameDrawn(function()	
	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition ) -- accepts vector2 or number,number
	if mouseHit then 
		outlineHoverBlock.size = mouseHit.size
		outlineHoverBlock.position = mouseHit.position
		outlineHoverBlock.opacity = 1
	else
		outlineHoverBlock.opacity = 0
	end

	if #selectedItems > 0 and redraw then
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
	elseif #selectedItems == 0 then
		outlineSelectedBlock.opacity = 0
	end
end)

engine.input:mouseLeftPressed(function( input )
	local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
	if not mouseHit then
		-- User clicked empty space, deselect everything??
		selectedItems = {}
		return
	end

	if not engine.input:isKeyDown(enums.key.leftShift) then
		-- deselect everything and move on
		selectedItems = {}
	else
		for i,v in pairs(selectedItems) do
			if v == mouseHit then
				-- deselect
				table.remove(selectedItems, i)
				return
			end
		end
	end

	table.insert(selectedItems, mouseHit)
end)

