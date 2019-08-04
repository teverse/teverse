local controller = {}

local uiController           = require("tevgit:create/controllers/ui.lua")
local themeController       = require("tevgit:create/controllers/theme.lua")
local dockController         = require("tevgit:create/controllers/dock.lua")
local selectionController    = require("tevgit:create/controllers/select.lua")

--dictionary of buttons to their corrosponding objects.
local buttonToObject = {}

local function updatePositions(frame)
  local y = 10
  if not frame then
    frame = controller.scrollView 
  else
    y = 20
  end

  for _,v in pairs(frame.children) do
    if v.name ~= "icon" then
      v.position = guiCoord(0, 10, 0, y)
      y = y + updatePositions(v)
    end
  end
  
  if type(frame) == "guiTextBox" then
    if y == 20 then 
      -- no children
      if buttonToObject[frame] and buttonToObject[frame].children and #buttonToObject[frame].children > 0 then
        --object has children but is not expanded
        frame.icon.texture = "fa:s-folder"
        frame.icon.imageAlpha = 1
        frame.textAlpha = 1
        frame.fontFile = "OpenSans-SemiBold.ttf"
      else
        --object has no children
        frame.icon.texture = "fa:r-folder"
        frame.icon.imageAlpha = .2
        frame.textAlpha = .6
        frame.fontFile = "OpenSans-Regular.ttf"
      end
    else
      -- object is expanded
      frame.textAlpha = 0.6
      frame.fontFile = "OpenSans-Regular.ttf"
      frame.icon.imageAlpha = 0.4
      frame.icon.texture = "fa:s-folder-open"
    end

    if buttonToObject[frame] and selectionController.isSelected(buttonToObject[frame]) then
      frame.backgroundAlpha = 0.3
    else
      frame.backgroundAlpha = 0
    end
  end

  return y
end

controller.updatePositions = updatePositions

local function createHierarchyButton(object, guiParent)
  local btn = uiController.create("guiTextBox", guiParent, {
    text            = "       " .. object.name, --ik...
    size            = guiCoord(1, -6, 0, 18),
    fontSize        = 16,
    cropChildren    = false,
    backgroundAlpha = 0,
    hoverCursor     = "fa:s-hand-pointer"
  }, "main")

  buttonToObject[btn] = object

  local icon = uiController.create("guiImage", btn, {
    name            = "icon",
    texture         = "fa:s-folder",
    position        = guiCoord(0, 1, 0, 1),
    size            = guiCoord(0, 16, 0, 16),
    handleEvents    = false,
    backgroundAlpha = 0
  })
  
  local expanded = false  
  local lastClick = 0
  
  btn:mouseLeftReleased(function()
    if os.time() - lastClick < 0.35 then
      lastClick = 0
      --expand
      expanded = not expanded
      if expanded then
        for _,child in pairs(object.children) do
          local btn = createHierarchyButton(child, btn)
        end
        updatePositions()
      else
        for _,v in pairs(btn.children) do
          if v.name ~= "icon" then
            if buttonToObject[v] then
              buttonToObject[v] = nil
            end
            v:destroy()
          end
        end
        updatePositions()
      end
    else
      --single click
      local currentTime = os.time()
      lastClick = currentTime

      selectionController.setSelection({object})
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
  updatePositions()
end

return controller