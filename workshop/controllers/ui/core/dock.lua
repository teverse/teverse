--[[
	
	work in progress
]]


local controller = {}

controller.saveDockSettings = function()
	-- Save dock to workshop settings
end

controller.loadDockSettings = function()
	-- Load Dock from settings
end

-- Invoked by a 3rd party script when user begins dragging window.
controller.beginWindowDrag = function(window, dontDock)
	-- change window appeareance (mainly for debugging) to make it clear this window is on the move.
	local startBorderAlpha = window.borderAlpha
	local startBorderWidth = window.borderWidth
	local startBorderColour = window.borderColour
	local startZ = window.zIndex

	window.zIndex = 99
	window.borderAlpha = 1
	window.borderWidth = 10
	window.borderColour = colour(1,.2,.2)

	-- offset used for dragging
	local offset = window.absolutePosition - engine.input.mousePosition

	-- undock window

	-- display dock locations to user

	-- yield until user releases window drag
	while engine.input:isMouseButtonDown(enums.mouseButton.left) do
		local newpos = engine.input.mousePosition + offset
		window.position = guiCoord(0, newpos.x, 0, newpos.y)

		if not dontDock then
			if engine.input.mousePosition.y >= engine.input.screenSize.y * 0.75 and
				engine.input.mousePosition.x < engine.input.screenSize.x * 0.75 then
				
				-- bottom dock
			elseif engine.input.mousePosition.x >= engine.input.screenSize.x * 0.75 then
				-- right dock
			else
				-- no dock
				helpers.outline.visible = false
			end
		end

		wait()
	end

	-- reset Window appearance
	window.zIndex = startZ
	window.borderAlpha = startBorderAlpha
	window.borderWidth = startBorderWidth
	window.borderColour = startBorderColour

	-- dock window

	-- save dock
end

return controller