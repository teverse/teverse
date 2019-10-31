local shared = require("tevgit:workshop/controllers/shared.lua")
local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")
local controller = {}

function roundToMultiple(number, multiple)
	if multiple == 0 then 
		return number 
	end
	
	return ((number % multiple) > multiple/2) and number + multiple - number%multiple or number - number%multiple
end

-- Used to sort objects by ZIndex.
-- This script uses the object's ZIndex to control the order in the dock
function numSorter(a,b)
	return a < b
end

function zSorter(a,b)
	return a.zIndex < b.zIndex
end

-- Currently only supposed to be called once,
-- it creates 'docks's that can hold other windows.
-- currently docks themselves are static and invisible,
-- this can easily be changed.
controller.setupDocks = function ()
	if controller.docks then
		-- delete old docks
		for _,dock in pairs(controller.docks) do
			for _,child in pairs(dock.children) do
				child.parent = dock.parent
			end

			dock:destroy()
		end
	end

	controller.docks = {
		engine.construct("guiFrame", shared.workshop.interface, {
			name = "_dockTop",
			size = guiCoord(1, -500, 0, 250 - 72),
			position = guiCoord(250, 0, 0, 72),
			backgroundAlpha = 0,
			handleEvents = false
		}),
		engine.construct("guiFrame", shared.workshop.interface, {
			name = "_dockLeft",
			size = guiCoord(0, 250, 1, -72),
			position = guiCoord(0, 0, 0, 72),
			backgroundAlpha = 0,
			handleEvents = false
		}),
		engine.construct("guiFrame", shared.workshop.interface, {
			name = "_dockBottom",
			size = guiCoord(1, -500, 0, 250),
			position = guiCoord(0, 250, 1, -250),
			backgroundAlpha = 0,
			handleEvents = false
		}),
		engine.construct("guiFrame", shared.workshop.interface, {
			name = "_dockRight",
			size = guiCoord(0, 250, 1, -72),
			position = guiCoord(1, -250, 0, 72),
			backgroundAlpha = 0,
			handleEvents = false
		})
	}
end

controller.setupDocks()

-- Store info about a window,
-- such as their pre-docked size
local windowDetails = {}

-- Ran whenever a dock's contents is changed
local function dockCallback(dock, isPreviewing)
	if dock.name == "_dockLeft" then
		print(#dock.children)
		shared.workshop.interface["_toolBar"].position = (#dock.children > 0 or isPreviewing) and guiCoord(0, 258, 0, 80) or guiCoord(0, 8, 0, 80)
	end
end

-- Adds a window to a dock
local function pushToDock(window, dock, slot)
	local perWindow = 1 / (#dock.children + 1)
	local isVertical = dock.absoluteSize.y > dock.absoluteSize.x

	-- sort zIndexes
	local children = dock.children
	table.sort(children, zSorter)

	local ii = 0
	for i,v in pairs(children) do
		if ii == slot then
			ii = ii + 1
		end
		v.zIndex = ii
		v.size = guiCoord(isVertical and 1 or perWindow, 0, isVertical and perWindow or 1, 0)
		v.position = guiCoord(isVertical and 0 or (perWindow*(ii)), 0, isVertical and (perWindow*(ii)) or 0, 0)
		ii = ii + 1
	end

	window.parent = dock
	window.size = guiCoord(isVertical and 1 or perWindow, 0, isVertical and perWindow or 1, 0)
	window.position = guiCoord(isVertical and 0 or (slot * perWindow), 0, isVertical and slot * perWindow or 0, 0)
	window.zIndex = slot
	dockCallback(dock)
end

-- Properly orders windows within a dock
-- useful when a window is removed
local function orderDock(dock)
	local perWindow = 1 / #dock.children
	local isVertical = dock.absoluteSize.y > dock.absoluteSize.x

	-- sort zIndexes
	local children = dock.children
	table.sort(children, zSorter)

	local ii = 0
	for i,v in pairs(children) do
		v.zIndex = ii
		v.size = guiCoord(isVertical and 1 or perWindow, 0, isVertical and perWindow or 1, 0)
		v.position = guiCoord(isVertical and 0 or (perWindow*(ii)), 0, isVertical and (perWindow*(ii)) or 0, 0)
		ii = ii + 1
	end
	dockCallback(dock)
end

-- returns the parent dock of a window if any
local function isInDock(window)
	for _,v in pairs(controller.docks) do
		if window:isDescendantOf(v) then
			return v
		end
	end
end


controller.saveDockSettings = function()
	-- Save dock to workshop settings
	local settings = {}
	for _,v in pairs(controller.docks) do
		settings[v.name] = {}

		local children = v.children
		table.sort(children, zSorter)

		for _,vv in pairs(children) do
			settings[v.name][vv.name] = vv.zIndex
		end

		shared.workshop:setSettings("workshopDocks", settings)
	end
end

-- used if docks haven't been saved before:
local defaultSettings = {
	["_dockRight"] = {
		["Hierarchy"] = 0,
		["Properties"] = 1
	}
}

controller.loadDockSettings = function()
	-- Load Dock from settings
	local settings = shared.workshop:getSettings("workshopDocks")
	if not settings then
		settings = defaultSettings
	end

	for dockName, windows in pairs(settings) do
		local dock = shared.workshop.interface:hasChild(dockName)
		if dock then
			for windowName, zIndex in pairs(windows) do
				local win = shared.workshop.interface:hasChild(windowName)
				if win then
					if not windowDetails[win] then
						windowDetails[win] = {zIndex = win.zIndex, size = win.size}
					end

					win.zIndex = zIndex
					win.parent = dock
				end
			end
		end
	end

	for _,v in pairs(controller.docks) do
		orderDock(v)
	end
end


-- Invoked by a 3rd party script when user begins dragging window.
controller.beginWindowDrag = function(window, dontDock)
	-- change window appeareance (mainly for debugging) to make it clear this window is on the move.
	if not windowDetails[window] then
		windowDetails[window] = {zIndex = window.zIndex, size = window.size}
	else
		window.size = windowDetails[window].size
	end

	window.zIndex = 99

	-- offset used for dragging
	local offset = window.absolutePosition - engine.input.mousePosition

	-- undock window
	local dock = isInDock(window)
	if dock then
		window.parent = dock.parent
		orderDock(dock)
	end

	local previewer = engine.construct("guiFrame", shared.workshop.interface, {
		handleEvents = false,
		visible = false,
		backgroundAlpha = 0.75
	})
	themer.registerGui(previewer, "primary")

	local isOverDock, slot;
	local lastDock;

	-- yield until user releases window drag
	while engine.input:isMouseButtonDown(enums.mouseButton.left) do
		local mPos = engine.input.mousePosition
		local newpos = mPos + offset
		window.position = guiCoord(0, newpos.x, 0, newpos.y)

		isOverDock = false

		if not dontDock then
			for _,dock in pairs(controller.docks) do
				-- the user's cursor is in this dock.
				if mPos.x > dock.absolutePosition.x and 
				 mPos.x < dock.absolutePosition.x + dock.absoluteSize.x and 
				 mPos.y > dock.absolutePosition.y and 
				 mPos.y < dock.absolutePosition.y + dock.absoluteSize.y then 
					
					local perWindow = 1 / (#dock.children + 1)
					local perWindowSize = perWindow * dock.absoluteSize
					local isVertical = dock.absoluteSize.y > dock.absoluteSize.x

					local pws = (isVertical and perWindowSize.y or perWindowSize.x)
					local m = (isVertical and mPos.y or mPos.x)
					local dockPosition = (isVertical and dock.absolutePosition.y or dock.absolutePosition.x)
					local dockSize = (isVertical and dock.absoluteSize.y or dock.absoluteSize.x)

					local mouseScaled =	(m - dockPosition) / dockSize
					slot = math.clamp((roundToMultiple(mouseScaled, perWindow) / perWindow), 0, (#dock.children))

					isOverDock = dock

					previewer.visible = true
					previewer.size = guiCoord(0, isVertical and dock.absoluteSize.x or pws, 0, isVertical and pws or dock.absoluteSize.y)
					previewer.position = guiCoord(0, isVertical and dock.absolutePosition.x or dock.absolutePosition.x + (slot * pws), 0, isVertical and dock.absolutePosition.y + (slot * pws) or dock.absolutePosition.y)

					local ii = 0
					local children = dock.children
					table.sort(children, zSorter)

					for i,v in pairs(children) do
						if ii == slot then
							ii = ii + 1
						end

						v.size = guiCoord(isVertical and 1 or perWindow, 0, isVertical and perWindow or 1, 0)
						v.position = guiCoord(isVertical and 0 or (perWindow*(ii)), 0, isVertical and (perWindow*(ii)) or 0, 0)
						ii = ii + 1
					end
					dockCallback(dock, true)
				end
			end
		end

		if (lastDock ~= isOverDock) then
			if lastDock then
				orderDock(lastDock) -- reorder old dock we were hovering
			end
			lastDock = isOverDock
		end

		if not isOverDock and previewer.visible then
			previewer.visible = false
		end

		wait()
	end

	if (lastDock and lastDock ~= isOverDock) then
		orderDock(lastDock) -- reorder old dock we were hovering
	end

	previewer:destroy()

	-- reset Window appearance
	window.zIndex = windowDetails[window].zIndex

	if isOverDock then
		pushToDock(window, isOverDock, slot)
	else
		windowDetails[window] = nil
	end

	-- save dock
	controller.saveDockSettings()
end

return controller
