local controller = {}

local themeController = require("tevgit:create/controllers/theme.lua")
controller.widgets = {}
controller.ui = nil

function controller.registerTabs(container, selectedStyle, deselectedStyle)
	controller.widgets[container] = {
		selected = selectedStyle,
		deselected = deselectedStyle,
		tabs = {},
		active = true,
		currentX = 10
	}
end

function controller.createTab(container, name, callback)
	if controller.widgets[container] then
		local active = controller.widgets[container].active
		controller.widgets[container].active = false

		local btn = controller.ui.create("guiTextBox", container, {
	        name = name,
	        size = guiCoord(0, 50, 0, 18),
	        position = guiCoord(0,controller.widgets[container].currentX,0,3),
	        text = name,
	        align = enums.align.middle,
	        hoverCursor = "fa:s-hand-pointer",
			fontSize = 18,
			readOnly = true
	    }, active and controller.widgets[container].selected or controller.widgets[container].deselected)

		controller.widgets[container].tabs[btn] = callback
		local newX = math.min(130, btn.textSize.x + 40)
		btn.size = guiCoord(0, newX, 0, 18)
		controller.widgets[container].currentX = controller.widgets[container].currentX + newX + 10

		if type(callback) ~= "function" and callback then
			-- callback not provided, assuming this was a gui passed, and that this controller should hide/show it
			callback.visible = active

			btn:mouseLeftReleased(function ()
				controller.setTab(container, btn)
			end)
		end
	end
end

function controller.setTab(container, onBtn)
	for btn, cb in pairs(controller.widgets[container].tabs) do
		controller.widgets[container].tabs[btn].visible = (btn == onBtn)
		themeController.add(btn, (btn==onBtn) and controller.widgets[container].selected or controller.widgets[container].deselected)
	end
end

return controller