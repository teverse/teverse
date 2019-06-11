--the purpose of this script is to unify all the tools
--by allowing each one to access the same common settings
--set by the user

local controller = {}
local uiController = require("tevgit:create/controllers/ui.lua")
local themeController = require("tevgit:create/controllers/theme.lua")

controller.gridStep = 1
controller.axis = {{"x", true},{"y", false},{"z", true}} -- should grid step be on .. axis

controller.window = nil
controller.workshop = nil

function controller.createUI(workshop)
  controller.workshop = workshop
  controller.window = uiController.createWindow(workshop.interface, guiCoord(0, 66, 0, 100), guiCoord(0, 140, 0, 73), "Tool settings")
  
  local toolsController = require("tevgit:create/controllers/tool.lua")
  local settingsBtn = toolsController.createButton("windowsTab", "fa:s-cogs", "Tool Settings")
  settingsBtn:mouseLeftReleased(function ()
    controller.window.visible = not controller.window.visible
  end)

  local gridLabel = uiController.create("guiTextBox", controller.window.content, {
  	size = guiCoord(0.5,-15,0,18),
  	position = guiCoord(0,5,0,4),
  	align = enums.align.middleRight,
  	text = "Grid Step"
  }, "mainText")

  local gridStepInput = uiController.create("guiTextBox", controller.window.content, {
  	size = guiCoord(0.5,-10,0,18),
  	position = guiCoord(0.5,5,0,4),
  	readOnly = false,
  	guiStyle = enums.guiStyle.rounded,
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
	  	guiStyle = enums.guiStyle.rounded,
	  	text = v[1] .. ":"
	}, "mainText")
  	x=x+20
  	local gridAxisInput = uiController.create("guiButton", controller.window.content, {
	  	size = guiCoord(0,22,0,18),
	  	position = guiCoord(0,x,0,28),
	  	text = "",
	  	selected = v[2],
	  	guiStyle = enums.guiStyle.checkBox
	}, "light")
	gridAxisInput:mouseLeftReleased(function ()
		controller.axis[i][2] = not controller.axis[i][2]
		gridAxisInput.selected = controller.axis[i][2]
	end)
	x=x+22
  end
end

return controller