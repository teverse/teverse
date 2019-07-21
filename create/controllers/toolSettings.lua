--the purpose of this script is to unify all the tools
--by allowing each one to access the same common settings
--set by the user

local controller = {}
local uiController = require("tevgit:create/controllers/ui.lua")
local themeController = require("tevgit:create/controllers/theme.lua")

controller.gridStep = 0.2
controller.rotateStep = 45
controller.axis = {{"x", true},{"y", true},{"z", true}} -- should grid step be on .. axis

controller.window = nil
controller.workshop = nil

function controller.createUI(workshop)
  controller.workshop = workshop
  controller.window = uiController.createWindow(workshop.interface, guiCoord(0, 66, 0, 100), guiCoord(0, 150, 0, 93), "Tool Settings")
  
  local toolsController = require("tevgit:create/controllers/tool.lua")
  local settingsBtn = toolsController.createButton("windowsTab", "fa:s-cogs", "Settings")
  settingsBtn:mouseLeftReleased(function ()
    controller.window.visible = not controller.window.visible
  end)

  local gridLabel = uiController.create("guiTextBox", controller.window.content, {
    size = guiCoord(0.5,-10,0,18),
    position = guiCoord(0,5,0,4),
    align = enums.align.middleRight,
    wrap = false,
    text = "Grid Step"
  }, "mainText")

  local gridStepInput = uiController.create("guiTextBox", controller.window.content, {
    size = guiCoord(0.5,-10,0,18),
    position = guiCoord(0.5,5,0,4),
    readOnly = false,
    align = enums.align.middle,
    borderRadius = 5,
    text = tostring(controller.gridStep)
  }, "main")

  gridStepInput:textInput(function ()
    local value = tonumber(gridStepInput.text)
    if value then
      controller.gridStep = value
    end
  end)


  local x = 5
  for i,v in pairs(controller.axis) do
  	local gridAxisLabel = uiController.create("guiTextBox", controller.window.content, {
	  	size = guiCoord(0,20,0,18),
	  	position = guiCoord(0,x,0,28),
      borderRadius = 5,
	  	text = v[1] .. ":"
	}, "mainText")
  	x=x+20
  	local gridAxisInput = uiController.create("guiButton", controller.window.content, {
	  	size = guiCoord(0,18,0,18),
	  	position = guiCoord(0,x,0,28),
	  	text = v[2] and "X" or " ",
	  	selected = v[2]
	}, "main")
	gridAxisInput:mouseLeftReleased(function ()
		controller.axis[i][2] = not controller.axis[i][2]
		gridAxisInput.selected = controller.axis[i][2]
    gridAxisInput.text = gridAxisInput.selected and "X" or " "
	end)
	x=x+22
  end


    local rotateLabel = uiController.create("guiTextBox", controller.window.content, {
    size = guiCoord(0.5,-10,0,18),
    position = guiCoord(0,5,0,50),
    align = enums.align.middleRight,
    wrap = false,
    text = "Rotate Step"
  }, "mainText")

  local rotateStepInput = uiController.create("guiTextBox", controller.window.content, {
    size = guiCoord(0.5,-10,0,18),
    position = guiCoord(0.5,5,0,50),
    readOnly = false,
    align = enums.align.middle,
    borderRadius = 5,
    text = tostring(controller.rotateStep)
  }, "main")

  rotateStepInput:textInput(function ()
    local value = tonumber(gridStepInput.text)
    if value then
      controller.rotateStep = value
    end
  end)


end

return controller