-- Copyright (c) 2019 teverse.com
-- ui.lua

local uiController = {}
local themeController = require("tevgit:create/controllers/theme.lua")
local toolsController = require("tevgit:create/controllers/tool.lua")
local uiTabController = require("tevgit:create/controllers/uiTabController.lua")
uiTabController.ui = uiController

uiController.create = function(className, parent, properties, style)
    local gui = engine.construct(className, parent, properties)
    themeController.add(gui, style and style or "default")
    return gui
end

uiController.createFrame = function(parent, properties, style)
    local gui = uiController.create("guiFrame", parent, properties, style)
    return gui
end

uiController.createWindow = function(parent, pos, size, title)
    local container = engine.construct("guiFrame", parent, {
        name = "windowContainer",
        position = pos,
        size = size
    })

    local titleBar = uiController.create("guiFrame", container, {
        name = "titleBar",
        size = guiCoord(1,0,0,22)
    }, "main")

    local textLabel = uiController.create("guiTextBox", titleBar, {
        name = "textLabel",
        readonly=true,
        size = guiCoord(1,-10,1,-2),
        position = guiCoord(0,5,0,0),
        text = title
    }, "mainText")

    uiController.createFrame(titleBar, {
        name = "borderBottom",
        size = guiCoord(1, 0, 0, 2),
        position = guiCoord(0,0,1,-2)
    }, "secondary")

    local content = uiController.create("guiFrame", container, {
        name = "content",
        position = guiCoord(0,0,0,22),
        size = guiCoord(1,0,1,-22)
    }, "mainTopBar")

    return container
end

local function spinCb()
    if not uiController.loadingFrame.visible then
        uiController.loadingTween.tweenObject.rotation = 0
        uiController.loadingTween:restart()
    end
end

uiController.setLoading = function(loading, message)
    if not uiController.loadingFrame then return end
    if loading then
        uiController.loadingFrame.visible = true
        uiController.loadingFrame.loadingMessage.text = message and message or "Loading"
        spinCb()
    else
        uiController.loadingFrame.visible = false
    end
end

uiController.createMainInterface = function(workshop)
    uiController.loadingFrame = uiController.create("guiFrame", workshop.interface, {
                                name = "loadingFrame",
                                size = guiCoord(0,300,0,100),
                                position = guiCoord(0.5,-150,0.5,-50),
                                guiStyle = enums.guiStyle.rounded
                            }, "main")

    uiController.create("guiTextBox", uiController.loadingFrame, {
        name = "loadingMessage",
        position = guiCoord(0, 10, 0.5, 0),
        size = guiCoord(1, -20, 0.5, -10),
        align = enums.align.middle,
        fontSize = 21,
        guiStyle = enums.guiStyle.noBackground,
        text = "Teverse is loading, don't touch right now!"
    }, "main")

    local loadingImage = uiController.create("guiImage", uiController.loadingFrame, {
        name = "loadingImage",
        position = guiCoord(0.5, -15, .333, -15),
        size = guiCoord(0, 30, 0, 30),
        texture = "fa:s-cog"
    }, "main")
    uiController.loadingTween = engine.tween:create(loadingImage, 1, {rotation = 360}, "inOutQuad", spinCb)

    local sideBar = uiController.createFrame(workshop.interface, {
        name = "toolbars",
        size = guiCoord(0,46,1,0),
        position = guiCoord(0,10,0,100)
    }, "mainTopBar")

    uiController.tabs = uiController.createFrame(workshop.interface, {
        name = "topbarTabs",
        size = guiCoord(1, 0, 0, 23),
        position = guiCoord(0,0,0,0)
    }, "main")

    uiController.createFrame(uiController.tabs, {
        name = "borderBottom",
        size = guiCoord(1, 0, 0, 2),
        position = guiCoord(0,0,1,-2)
    }, "secondary")

    uiController.topBar = uiController.createFrame(workshop.interface, {
        name = "topbar",
        size = guiCoord(1, 0, 0, 60),
        position = guiCoord(0,0,0,23)
    }, "mainTopBar")

    uiController.windowsTab = uiController.createFrame(workshop.interface, {
        name = "windowsTab",
        size = guiCoord(1, 0, 0, 60),
        position = guiCoord(0,0,0,23)
    }, "mainTopBar")

    local tabController = uiTabController.registerTabs(uiController.tabs, "secondary", "main")
    uiTabController.createTab(uiController.tabs, "File", uiController.topBar)
    uiTabController.createTab(uiController.tabs, "Windows", uiController.windowsTab)


    toolsController.container = sideBar
    toolsController.workshop = workshop
    toolsController.ui = uiController

    toolsController.registerMenu("windowsTab", uiController.windowsTab)

    --[[local darkmode = true
    toolsController.createButton("windowsTab", "fa:s-palette", "Switch themes"):mouseLeftReleased(function ()
        darkmode = not darkmode 
        if not darkmode then
            themeController.set(themeController.lightTheme)
        else
            themeController.set(themeController.darkTheme)
        end
    end)]]
    

    toolsController.registerMenu("topBar", uiController.topBar)
    local saveBtn = toolsController.createButton("topBar", "fa:s-file-download", "Save")
    local saveAsBtn = toolsController.createButton("topBar", "fa:s-file-export", "Save As")
    local openBtn = toolsController.createButton("topBar", "fa:s-folder-open", "Open")
    local publishBtn = toolsController.createButton("topBar", "fa:s-cloud-upload-alt", "Publish")

    --[[
    local function checkIfPublishable()
        settingsBar.btn.visible = (engine.workshop.gameFilePath ~= "")
        settingsBar.publishNote.text = (engine.workshop.gameFilePath == "" and "You need to save this game before publishing." or "This file isn't linked to the TevCloud.")
        settingsBar.btn.label.text = (engine.workshop.gameCloudId == "" and "Publish" or "Update")

        if engine.workshop.gameCloudId ~= "" then
            settingsBar.publishNote.text = "This is a TevCloud project."
        end
    end

    checkIfPublishable()
    engine.workshop:changed(checkIfPublishable)
    ]]

    saveBtn:mouseLeftReleased(function()
        workshop:saveGame()
    end)
    saveAsBtn:mouseLeftReleased(function()
        workshop:saveGameAsDialogue()
    end)
    openBtn:mouseLeftReleased(function()
        workshop:openFileDialogue()
    end)
    publishBtn:mouseLeftReleased(function ()
        workshop:publishDialogue()
    end)
end

return uiController
