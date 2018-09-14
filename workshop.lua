 -- Copyright (c) 2018 teverse.com
 -- workshop.lua

local menuBarTop = engine.guiMenuBar()
menuBarTop.size = guiCoord(1, 0, 0, 19)
menuBarTop.position = guiCoord(0, 0, 0, 0)
menuBarTop.parent = workshop.interface

local menuFile = menuBarTop:createItem("File")
local menuNew = menuFile:createItem("New")
