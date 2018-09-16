 -- Copyright (c) 2018 teverse.com
 -- workshop.lua

workshop.interface:setTheme(enums.themes.dark)

local menuBarTop = engine.guiMenuBar()
menuBarTop.size = guiCoord(1, 0, 0, 19)
menuBarTop.position = guiCoord(0, 0, 0, 0)
menuBarTop.parent = workshop.interface

local menuFile = menuBarTop:createItem("File")
local menuFileNew = menuFile:createItem("New Scene")
local menuFileOpen = menuFile:createItem("Open Scene")
local menuFileSave = menuFile:createItem("Save Scene")
local menuFileSaveAs = menuFile:createItem("Save Scene As")

local menuEdit = menuBarTop:createItem("Edit")
local menuEditUndo = menuEdit:createItem("Undo")
local menuEditRedo = menuEdit:createItem("Redo")

local workspaceTheme = menuBarTop:createItem("Theme")
local darkTheme = menuBarTop:createItem("Dark Mode")
local brightTheme = menuBarTop:createItem("Bright mode") -- if people want to blind themselves, let them.

local menuInsert = menuBarTop:createItem("Insert")
local menuInsertBlock = menuInsert:createItem("Block")

darkTheme:mouseLeftPressed(function ()
	-- Set theme to dark mode when dark mode button clicked.
	workshop.interface:setTheme(enum.themes.dark)
end)
brightTheme:mouseLeftPressed(function ()
	-- Set theme to bright/blind mode when bright mode button clicked.
	local success,message = pcall(function () 
		workshop.interface:setTheme(enum.themes.light)
	end)
	-- TODO: make sure this is an actual theme
	-- pcall just to be safe
	if not success then
		-- again, just to be safe, tostring on the message.
		error("workshop.lua: Color theme error: "..tostring(message))
	end
end)

-- Block creation function. Creates a new block and positions it relative to the user's camera
menuInsertBlock:mouseLeftPressed(function ()
	local newBlock = engine.block("block")
	newBlock.parent = workspace

	local camera = workspace.camera
		
	local lookVector = camera.rotation * vector3(0, 0, 1)
	newBlock.position = camera.position + (lookVector * 10)
end)

-- Record changes for undo/redo WIP
local history = {}
local dirty = {} -- record things that have changed since last action
local currentStep = 0 -- the current point in history used to undo 
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
end)

menuEditUndo:mouseLeftPressed(function ()
	currentPoint = currentPoint - 1
	local snapShot = history[currentPoint] 
		
	goingBack = true
	for object, properties in pairs(snapShot) do
		for property, value in pairs(properties) do
			object[property] = value
		end
	end
	goingBack = false
end)
