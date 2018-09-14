 -- Copyright (c) 2018 teverse.com
 -- workshop.lua

local menuBarTop = engine.guiMenuBar()
menuBarTop.size = guiCoord(1, 0, 0, 19)
menuBarTop.position = guiCoord(0, 0, 0, 0)
menuBarTop.parent = workshop.interface

local menuFile = menuBarTop:createItem("File")
local menuNew = menuFile:createItem("New")
local makeBlock = menuFile:createItem("New block")

-- Block creation function. Creates a new block and positions it relative to the user's camera.
makeBlock:mouseLeftPressed(function ()
	local newBlock = engine.block("block")
	newBlock.parent = workspace

	local camera = workspace.camera
	local cameraPos = camera.position
	-- not sure if this how to get look vector
	local lookVector = camera.rotation * vector3(0, 0, 1)
	-- absolutely no idea where this positions it.
	local addVector = vector3(2, 0, 0)
	newBlock.position = lookVector + addVector

end)
