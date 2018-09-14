 -- Copyright (c) 2018 teverse.com
 -- workshop.lua

local menuBarTop = engine.guiMenuBar()
menuBarTop.size = guiCoord(1, 0, 0, 19)
menuBarTop.position = guiCoord(0, 0, 0, 0)
menuBarTop.parent = workshop.interface

local menuFile = menuBarTop:createItem("File")
local menuFileNew = menuFile:createItem("New")

local menuInsert = menuBarTop:createItem("Insert")
local makeBlock = menuInsert:createItem("Block")

-- Block creation function. Creates a new block and positions it relative to the user's camera.
makeBlock:mouseLeftPressed(function ()
	local newBlock = engine.block("block")
	newBlock.parent = workspace

	local camera = workspace.camera

	local lookVector = camera.rotation * vector3(0, 0, 1)
	newBlock.position = camera.position + (lookVector * 10)

end)
