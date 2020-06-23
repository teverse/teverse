-- Copyright 2020- Teverse
-- This script is responsible for creating the workshop interface

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files
local topbarInterface = require("tevgit:workshop/library/ui/controllers/topbarInterface.lua") -- UI Controller
local sidebarInterface = require("tevgit:workshop/library/ui/controllers/sidebarInterface.lua") -- UI Controller

local topBar = topbarInterface.construct("horizontalNavbar", "Test Place 1") -- Create initial topbar instance
local sideBar = sidebarInterface.construct("verticalNavbar") -- Create initial sidebar instance

-- Register default tools to topbar instance
topBar.registerIcon("sliders-h", nil)
topBar.registerIcon("arrow-right", nil)
topBar.registerIcon("arrow-left", nil)

-- Register default tools to sidebar instance
sideBar.registerDefaultIcon("location-arrow", nil)
sideBar.registerDefaultIcon("arrows-alt-h", nil)
sideBar.registerDefaultIcon("sync", nil)
sideBar.registerDefaultIcon("expand", nil)

local defaultPage = sideBar.registerPage("Default") -- Register default page to sidebar instance
defaultPage.registerIcon("openFolderIcon", "folder-open", nil)
defaultPage.registerIcon("newFileIcon", "file", nil)
defaultPage.registerIcon("uploadFileIcon", "file-upload", nil)
defaultPage.registerIcon("downloadFileIcon", "file-download", nil)
defaultPage.registerIcon("importFileIcon", "file-import", nil)
defaultPage.registerIcon("exportFileIcon", "file-export", nil)
--globals.sideBarPageDefault = defaultPage -- Set default sidebar page to default
--globals.sideBarPageActive = defaultPage -- Set default sidebar page as active


local designPage = sideBar.registerPage("Design") -- Register design page to sidebar instance
designPage.registerIcon("screenContainerIcon", "tv", nil)
designPage.registerIcon("guiFrameIcon", "square-full", nil)
designPage.registerIcon("guiTextBoxIcon", "i-cursor", nil)
designPage.registerIcon("guiImageIcon", "image", nil)

--[[
local modelPage = sideBar.registerPage("Model") -- Register model page to sidebar instance
modelPage.registerIcon("modelIcon", "shapes", nil)

local insertPage = sideBar.registerPage("Insert") -- Register insert page to sidebar instance
insertPage.registerIcon("blockIcon", "cube", nil)
insertPage.registerIcon("circleIcon", "circle", nil)
insertPage.registerIcon("scriptIcon", "code", nil)
insertPage.registerIcon("lightIcon", "lightbulb", nil)

local testPage = sideBar.registerPage("Test") -- Register test page to sidebar instance
testPage.registerIcon("consoleIcon", "terminal", nil)
testPage.registerIcon("playIcon", "play", nil)
testPage.registerIcon("serverIcon", "server", nil)
testPage.registerIcon("fullScreenIcon", "expand-alt", nil)
]]--

-- Bind pages to labels in menu
topBar.bindDefaultMenu(defaultPage.getContainer())
topBar.bindMenu("Design", designPage.getContainer())
--topBar.bindMenu("Model", modelPage.getContainer())
--topBar.bindMenu("Insert", insertPage.getContainer())
--topBar.bindMenu("Test", testPage.getContainer())





--[[
-- Register topbar button (name labels) to topbar instance
topBar.register("Design", "Design your guis", designPage)
topBar.register("Model", "Model your scene", modelPage)
topBar.register("Insert", "Insert an instance to your scene", insertPage)
topBar.register("Test", "Test your scene", testPage)
]]--