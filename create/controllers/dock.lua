local controller = {}

controller.ui = nil
controller.dockDictionary = {}
controller.bottomDock = {}
controller.rightDock = {}

-- direction: up, down, left or right
local function renderHelper(parent, direction, pos)
	local frame = controller.ui.create("guiFrame", parent, {
		name = "locationHelper" .. direction,
		size = guiCoord(0, 40, 0, 40),
		borderRadius = 5,
		borderWidth = 1,
		borderAlpha = 1
	}, "light")

	if pos then
		frame.position = pos
	end

	controller.ui.create("guiImage", frame, {
		size = guiCoord(0, 12, 0, 12),
		position = guiCoord(0.5,-6,0,5),
		texture = "fa:s-arrow-" .. direction
	}, "light")

	controller.ui.create("guiImage", frame, {
		size = guiCoord(0, 18, 0, 18),
		position = guiCoord(0.5,-9,0,18),
		alpha = 0.75,
		texture = "fa:r-window-maximize"
	}, "light")

	return frame
end

controller.renderDockLocationHelpers = function()
	local helpers = engine.construct("guiFrame", controller.ui.workshop.interface, { zIndex=100, size = guiCoord(1,0,1,0), alpha = 0, handleEvents=false})

	local outline = controller.ui.create("guiFrame", helpers, {
		name = "outline",
		size = guiCoord(0, 100, 0, 220),
		alpha = 0,
		borderRadius = 2,
		borderWidth = 1,
		borderAlpha = 1,
		visible = false
	}, "light")

	if #controller.bottomDock == 0 then
		renderHelper(helpers, "down", guiCoord(0.5, -20, 0.9, -20))
	else

	end

	if #controller.rightDock == 0 then
		renderHelper(helpers, "right", guiCoord(0.9, -20, 0.5, -20))
	else
		for i,v in pairs(controller.rightDock) do
			renderHelper(helpers, "right", guiCoord(0.9, -20, 0, v.absolutePosition.y + 20))
			if i == #controller.rightDock then
				renderHelper(helpers, "right", guiCoord(0.9, -20, 0, v.absolutePosition.y + v.absoluteSize.y - 40))
			end
		end
	end

	return helpers
end

controller.undockWindow = function(window)
	local dockDic = controller.dockDictionary[window]
	controller.dockDictionary[window] = nil
	if dockDic then
		if dockDic == 0 then
			for i,v in pairs(controller.bottomDock) do
				if v == window then
					table.remove(controller.bottomDock, i)

					local scale = 1
					if #controller.rightDock > 0 then
						scale = 0.8
					end

					for i,v in pairs(controller.bottomDock) do
						engine.tween:begin(v, 0.1, {
							size = guiCoord(scale*(1/#controller.bottomDock), 0, 0.2, 0),
							position = guiCoord(scale*((i-1) * (1/#controller.bottomDock)), 0, 0.8, 0)
						}, "inOutQuad")
					end
					return
				end
			end
		elseif dockDic == 1 then
			for i,v in pairs(controller.rightDock) do
				if v == window then
					table.remove(controller.rightDock, i)
					for i,v in pairs(controller.rightDock) do
						engine.tween:begin(v, 0.1, {
							size = guiCoord(0.2, 0, 1/#controller.rightDock, i == 1 and -83 or 0),
							position = guiCoord(0.8,0,(i-1) * (1/#controller.rightDock), i == 1 and 83 or 0)
						}, "inOutQuad")
					end
					return
				end
			end
		end
	end
end

controller.dockWindow = function(window, dock, pos)
	controller.undockWindow(window)
	if dock == controller.bottomDock then
		controller.dockDictionary[window] = 0
		table.insert(controller.bottomDock, window)

		local scale = 1
		if #controller.rightDock > 0 then
			scale = 0.8
		end

		for i,v in pairs(controller.bottomDock) do
			engine.tween:begin(v, 0.1, {
				size = guiCoord(scale*(1/#controller.bottomDock), 0, 0.2, 0),
				position = guiCoord(scale*((i-1) * (1/#controller.bottomDock)), 0, 0.8, 0)
			}, "inOutQuad")
		end
	elseif dock == controller.rightDock then
		controller.dockDictionary[window] = 1
		table.insert(controller.rightDock, window)
		for i,v in pairs(controller.rightDock) do
			engine.tween:begin(v, 0.1, {
				size = guiCoord(0.2, 0, 1/#controller.rightDock, i == 1 and -83 or 0),
				position = guiCoord(0.8,0,(i-1) * (1/#controller.rightDock), i == 1 and 83 or 0)
			}, "inOutQuad")
		end
	end
end

-- window should be a window created in ui.lua... it's a guiframe consisting of other guis.
-- this function should be called when the user begins dragging on a window
controller.beginWindowDrag = function(window)
	controller.undockWindow(window)
	local offset = window.absolutePosition - engine.input.mousePosition
	local startAlpha = window.alpha

	window.alpha = startAlpha*0.5;
	local helpers = controller.renderDockLocationHelpers()

	local selectedPosition = window.position
	local selectedSize = window.size

	while engine.input:isMouseButtonDown(enums.mouseButton.left) do
		local newpos = engine.input.mousePosition + offset
		window.position = guiCoord(0, newpos.x, 0, newpos.y)

		if engine.input.mousePosition.y >= engine.input.screenSize.y * 0.75 then
			helpers.outline.size = guiCoord(1, 0, 0.2, 0)
			helpers.outline.position = guiCoord(0, 0, 0.8, 0)
			helpers.outline.visible = true
		elseif engine.input.mousePosition.x >= engine.input.screenSize.x * 0.75 then
			helpers.outline.size = guiCoord(0.2, 0, 1, 0)
			helpers.outline.position = guiCoord(0.8, 0, 0, 0)
			helpers.outline.visible = true
		else
			helpers.outline.visible = false
		end

		wait()
	end
	helpers:destroy()
	if engine.input.mousePosition.y >= engine.input.screenSize.y * 0.75 then
		controller.dockWindow(window, controller.bottomDock)
	elseif engine.input.mousePosition.x >= engine.input.screenSize.x * 0.75 then
		controller.dockWindow(window, controller.rightDock)
	end

	window.alpha = startAlpha
end

return controller