-- Context Menu Helper

local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local controller = {}
controller.currentContextMenu = nil

engine.input:mouseLeftReleased(function ()
	if controller.currentContextMenu then
		local focusedGui = engine.input.mouseFocusedGui
		-- The mouse was clicked...
		-- If there is no gui in focus, 
		-- or if the focused gui is not the context menu
		-- ... we remove the context menu
		if not focusedGui or (focusedGui ~= controller.currentContextMenu and not focusedGui:isDescendantOf(controller.currentContextMenu)) then
			controller.currentContextMenu:destroy()
			controller.currentContextMenu = nil
		end
	end
end)

-- Merely to demonstate the different options possible or to test the context menu helper.
controller.exampleOptions = {
	{name = "Option 1", callback = function() print("callback") end},
	{name = "Option 2"},
	{name = "Option 3"}
}

-- Generates the menu and removes any old menus.
controller.generateMenu = function(options, position)

	-- Destroy any preexisting context menu
	if controller.currentContextMenu then
		controller.currentContextMenu:destroy()
		controller.currentContextMenu = nil
	end

	-- If the calling function did not provide a position for the context menu,
	-- we default to the user's cursor position.
	if not position or not type(position) == "guiCoord" then
		position = guiCoord(0, engine.input.mousePosition.x, 0, engine.input.mousePosition.y)
	end

	-- create the context gui main frame, styled.
	local menu = ui.create("guiFrame", shared.workshop.interface, {
		name = "_contextMenu",
		zIndex = 10000,
		position = position
	}, "primary")

	-- so we can delete it later
	controller.currentContextMenu = menu

	local yPos = 6

	-- create a gui for each option provided
	for _,option in pairs(options) do
		local btn = ui.create("guiTextBox", menu, {
			size = guiCoord(0.8, 0, 0, 20),
			position = guiCoord(0.1, 0, 0, yPos),
			align = enums.align.middleLeft,
			text = option.name,
			textAlpha = 0.6
		}, "primaryText")

		if option.callback then
			btn:mouseLeftReleased(function ()
				option.callback()
				menu:destroy()
				controller.currentContextMenu = nil
			end)
		end

		-- Improves accessibility
		btn:mouseFocused(function ()
			btn.textAlpha = 1
		end)

		btn:mouseUnfocused(function ()
			btn.textAlpha = 0.6
		end)

		yPos = yPos + 26
	end

	-- make the main container the right size.
	menu.size = guiCoord(0, 160, 0, yPos)
end

controller.bind = function(object, options)
	if not object.mouseRightReleased then
		return warn("Could not hook onto mouse event?!")
	end

	object:on("mouseRightReleased", function()
		controller.generateMenu(options)
	end)
end

return controller