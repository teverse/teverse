-- Selection Controller is incharge of storing and managing the user’s selection 

local controller = {}

controller.selection = {}

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
	controller.addSelection(obj)
end

controller.addSelection = function(obj)
	if type(obj) == "table" then
		for _,v in pairs(obj) do
			table.insert(controller.selection, v)
		end
	else
		table.insert(controller.selection, obj)
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

return controller