local controller = {}

local uiController           = require("tevgit:create/controllers/ui.lua")
local themeControl ler        = require("tevgit:create/controllers/theme.lua")
local colourPickerController = require("tevgit:create/extras/colourPicker.lua")
local dockController         = require("tevgit:create/controllers/dock.lua")

local function updatePositions(frame)
  if not frame then frame = controller.scrollView end
  local y = 0
  for _,v in pairs(frame.children) do
    v.position = guiCoord(0, 3, 0, y)
    y = y + 20
    y = y + updatePositions(v)
  end
  
  return y
end

local function createHierarchyButton(object, guiParent)
  local btn = uiController.create("guiTextBox", guiParent, {
    text      = object.name,
    size      = guiCoord(1, -6, 0, 18),
    fontSize  = 16
  }, "mainTopBar")
  
  local expanded = false  
  
  btn:mouseLeftReleased(function()
    expanded = not expanded
    if expanded then
      for _,child in pairs(object.children) do
        local btn = createHierarchyButton(child, btn)
      end
      updatePositions()
    else
      object:destroyAllChildren()
      updatePositions()
    end
  end)
  
  return btn
end

function controller.createUI(workshop)
  controller.window = uiController.createWindow(workshop.interface, 
                                                guiCoord(1, -300, 1, -400), -- pos
                                                guiCoord(0, 250, 0, 400),   -- size
                                                "Hierarchy")
  controller.window.visible = true

  dockController.dockWindow(controller.window, dockController.rightDock)
  
  controller.scrollView = uiController.create("guiScrollView", controller.window.content, {
    name = "scrollview",
    size = guiCoord(1, 0, 1, 0)
  }, "mainTopBar")

  local toolsController = require("tevgit:create/controllers/tool.lua")
  local hierarchyBtn = toolsController.createButton("windowsTab", "fa:s-sitemap", "Hierarchy")
  hierarchyBtn:mouseLeftReleased(function ()
    controller.window.visible = not controller.window.visible
  end)  
  
  createHierarchyButton(engine, controller.scrollView)
end

return controller