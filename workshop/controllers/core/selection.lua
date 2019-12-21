-- Selection Controller is incharge of storing and managing the user’s selection 

local controller = {}

local boundingBox = engine.construct("block", workspace, {
	name = "_bounding",
	wireframe = true,
	static = true,
	physics = false,
	workshopLocked = true,
	doNotSerialise = true,
	position = vector3(0, -100, 0)
})

controller.selection = {}
controller.destroyingListeners = {}

controller.callbacks = {}

controller.fireCallbacks = function ()
	for _,v in pairs(controller.callbacks) do
		v()
	end
end

controller.registerCallback = function (cb)
	table.insert(controller.callbacks, cb)
end

controller.setSelection = function(obj)
	controller.selection = {}

	for _,v in pairs(controller.destroyingListeners) do
		v:disconnect()
	end
	controller.destroyingListeners = {}

	controller.addSelection(obj)
end

local function destroyListener()
	for i,v in pairs(controller.selection) do
		if v == self.object then
			table.remove(controller.selection, i)
			break
		end
	end

	controller.destroyingListeners[self.object] = nil

	self:disconnect()
end

controller.addSelection = function(obj)
	if type(obj) == "table" then
		for _,v in pairs(obj) do
			if v.isA and v:isA("baseClass") and not v.workshopLocked then
				table.insert(controller.selection, v)
				controller.destroyingListeners[v] = v:once("destroying", destroyListener)
			else
				warn("selecting unknown object")
			end
		end
	else
		if obj.isA and obj:isA("baseClass") then
			table.insert(controller.selection, obj)
			controller.destroyingListeners[obj] = obj:once("destroying", destroyListener)
		else
			warn("selecting unknown object")
		end
	end
	controller.fireCallbacks()
end

controller.isSelected = function(obj)
	for _,v in pairs(controller.selection) do
		if v == obj then
			return true
		end
	end
end

controller.hasSelection = function()
	return #controller.selection > 0
end

local boundingEvents = {}

local function boundUpdate() 
	if not boundingBox or not boundingBox.alive then return end

	--inefficient, is called for each change
	local bounds = aabb()

	if #controller.selection > 0 and controller.selection[1].position then
		bounds.min = controller.selection[1].position
		bounds.max = controller.selection[1].position

		for _,v in pairs(controller.selection) do
			bounds:expand(v) -- new in 0.13.2
		end
	end

	boundingBox.position = bounds:getCentre()
	boundingBox.size = bounds.max - bounds.min
end

-- on selection changed
controller.registerCallback(function()
	for _,v in pairs(boundingEvents) do
		v:disconnect()
	end
	boundingEvents = {}

	if not boundingBox or not boundingBox.alive then return end

	local bounds = aabb()

	if #controller.selection > 0 and type(controller.selection[1].position) == "vector3" then
		bounds.min = controller.selection[1].position
		bounds.max = controller.selection[1].position

		for _,v in pairs(controller.selection) do
			if type(v.position) == "vector3" and type(v.size) == "vector3" then
				bounds:expand(v)
				table.insert(boundingEvents, v:changed(boundUpdate))
			end
		end
	end

	boundingBox.position = bounds:getCentre()
	boundingBox.size = bounds.max - bounds.min
end)


local keybinder = require("tevgit:workshop/controllers/core/keybinder.lua")
local history = require("tevgit:workshop/controllers/core/history.lua")

keybinder:bind({
    name = "delete",
    key = enums.key.delete,
	action = function()
		history.beginAction(controller.selection, "Delete")
		for _,v in pairs(controller.selection) do
			v:destroy()
		end
		history.endAction()
	end
})

keybinder:bind({
    name = "select all",
	key = enums.key.a,
	priorKey = enums.key.leftCtrl,
	action = function()
		local children = workspace.children
		for i,v in pairs(children) do
			if v:isA("camera") then
				table.remove(children, i)
			end
		end
		controller.setSelection(children)
	end
})

keybinder:bind({
    name = "focus",
    key = enums.key.f,
	action = function()
		-- calculate the 'centre' of the selection
		local bounds = aabb()

		if #controller.selection > 0 then
			bounds.min = controller.selection[1].position
			bounds.max = controller.selection[1].position
		end

		for _,v in pairs(controller.selection) do
			bounds:expand(v.position + (v.size/2))
			bounds:expand(v.position - (v.size/2))
		end

		local centre = bounds:getCentre()

		workspace.camera:lookAt(centre)
	end
})

return controller