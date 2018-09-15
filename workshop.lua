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

local menuInsert = menuBarTop:createItem("Insert")
local menuInsertBlock = menuInsert:createItem("Block")

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
local changedEvents = {} -- store handlers to disconnect 

local function objectChanged(property)
	-- TODO: self is a reference to an event object
	-- self.object is what the event is about
	-- self:disconnect() is used to disconnect this handler
	
	if not dirty[self.object] then 
		dirty[self.object] = {}
	end
	
	if not dirty[self.object][property] then
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
	
	table.insert(history, newPoint)
	dirty = {}
end

-- hook existing objects
for _,v in pairs(workspace.children) do
	v:changed(objectChanged)
end

workspace:childAdded(function(child)
	child:changed(objectChanged)
end)
