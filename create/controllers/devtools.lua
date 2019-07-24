-- Mean to be a module dedicated to debugging create mode?

local toolsController = require("tevgit:create/controllers/tool.lua")
local uiController = require("tevgit:create/controllers/ui.lua")
local uiTabController = require("tevgit:create/controllers/uiTabController.lua")


    uiController.devTab = uiController.createFrame(uiController.workshop.interface, {
        name = "devTab",
        size = guiCoord(1, 0, 0, 60),
        position = guiCoord(0,0,0,23)
    }, "mainTopBar")

    uiTabController.createTab(uiController.tabs, "Dev [ignore this]", uiController.devTab)


toolsController.registerMenu("devTab", uiController.devTab)

local reloadButton = toolsController.createButton("devTab", "fa:s-sync", "Reload all")
reloadButton:mouseLeftReleased(function ()
	engine.input.cursorTexture = "fa:s-mouse-pointer"
    uiController.workshop:reloadCreate()
end)


local gcWindow = uiController.createWindow(uiController.workshop.interface, guiCoord(0.5, -150, 0, 300), guiCoord(0, 300, 0, 93), "GC", true) --undockable window
gcWindow.visible = false
gcWindow.zIndex = 2000

local gcText = uiController.create("guiTextBox", gcWindow.content, {
	size = guiCoord(1,-20,1,-40),
	position = guiCoord(0,10,0,10),
	wrap = true
}, "mainText")

local gcnow = uiController.create("guiButton", gcWindow.content, {
	size = guiCoord(1,-20,0,20),
	position= guiCoord(0,10,1,-25),
	text = "collectgarbage()"
}, "main")

gcnow:mouseLeftReleased(function ()
	collectgarbage()
end)

local garbageButton = toolsController.createButton("devTab", "fa:s-trash-alt", "GC")
garbageButton:mouseLeftReleased(function ()
   	gcWindow.visible = not gcWindow.visible

   	spawnThread(function ()
		while gcWindow.visible do 
			gcText.text = string.format("Memory Usage %.3f MB", collectgarbage( "count" ) / 1024)
			wait(.1)
		end
	end)	
end)
