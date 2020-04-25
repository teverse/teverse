-- Copyright 2020- Teverse
-- This script is responsible for creating the workshop interface

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files
--local prompt = require("tevgit:workshop/library/ui/components/prompt.lua") -- UI Component
local topbarInterface = require("tevgit:workshop/library/ui/controllers/topbarInterface.lua") -- UI Controller
local sidebarInterface = require("tevgit:workshop/library/ui/controllers/sidebarInterface.lua") -- UI Controller

local topBar = topbarInterface.construct("horizontalNavbar", "cloud", "Test Place 1") -- Create initial topbar instance
local sideBar = sidebarInterface.construct("verticalNavbar") -- Create initial sidebar instance

local defaultPage = sideBar.registerPage("Default") -- Register default page to sidebar instance
sideBar.registerIcon(defaultPage, "openFolderIcon", "folder-open", "Open Folder", nil) 
sideBar.registerIcon(defaultPage, "newFileIcon", "file", "Create new file", nil)
sideBar.registerIcon(defaultPage, "uploadFileIcon", "file-upload", "Upload current file", nil)
sideBar.registerIcon(defaultPage, "downloadFileIcon", "file-download", "Download current file", nil)
sideBar.registerIcon(defaultPage, "importFileIcon", "file-import", "Import a file", nil, -0.048, guiCoord(0.048, 0, 0, 0))
sideBar.registerIcon(defaultPage, "exportFileIcon", "file-export", "Export current file", nil, 0.048, guiCoord(-0.048, 0, 0, 0))
defaultPage.visible = true -- Set default sidebar page to visible
globals.sideBarPageDefault = defaultPage -- Set default sidebar page to default
globals.sideBarPageActive = defaultPage -- Set default sidebar page as active


local designPage = sideBar.registerPage("Design") -- Design default page to sidebar instance
sideBar.registerIcon(designPage, "screenContainerIcon", "tv", "Create a container instance", nil)
sideBar.registerIcon(designPage, "guiFrameIcon", "square-full", "Create a guiFrame instance", nil)
sideBar.registerIcon(designPage, "guiTextBoxIcon", "i-cursor", "Create a guiTextBox instance", nil)
sideBar.registerIcon(designPage, "guiImageIcon", "image", "Create a guiImage instance", nil)


local modelPage = sideBar.registerPage("Model") -- Register model page to sidebar instance
sideBar.registerIcon(modelPage, "modelIcon", "shapes", "Group instance(s) together", nil)


local insertPage = sideBar.registerPage("Insert") -- Register insert page to sidebar instance
sideBar.registerIcon(insertPage, "blockIcon", "cube", "Create a cube instance", nil)
sideBar.registerIcon(insertPage, "circleIcon", "circle", "Create a cylinder instance", nil)
--sideBar.registerIcon(designPage, "triangleIcon", "i-cursor", nil, nil) -- Triangle / Wedge Icon doesn't exist
sideBar.registerIcon(insertPage, "scriptIcon", "code", "Create a script instance", nil)
sideBar.registerIcon(insertPage, "lightIcon", "lightbulb", "Create a light instance", nil)


local testPage = sideBar.registerPage("Test") -- Register test page to sidebar instance
sideBar.registerIcon(testPage, "consoleIcon", "terminal", " Open console window", nil)
sideBar.registerIcon(testPage, "playIcon", "play", "Play scene", nil)
sideBar.registerIcon(testPage, "serverIcon", "server", "Configure server", nil)
sideBar.registerIcon(testPage, "fullScreenIcon", "fullscreen", "Toggle full screen", nil)



-- Register topbar button (name labels) to topbar instance
topBar.register("Design", "Design your guis", designPage)
topBar.register("Model", "Model your scene", modelPage)
topBar.register("Insert", "Insert an instance to your scene", insertPage)
topBar.register("Test", "Test your scene", testPage)