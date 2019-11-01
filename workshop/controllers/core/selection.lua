-- Selection Controller is incharge of storing and managing the user’s selection 

local controller = {}

controller.selection = {}

controller.callbacks = {}

controller.fireCallbacks = function ()
	for _,v in pairs(controller.callbacks) do
		print("firing")
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
	print("test test")
	if type(obj) == "table" then
		for _,v in pairs(obj) do
			if v.isA and v:isA("baseClass") then
				table.insert(controller.selection, v)
			else
				warn("selecting unknown object")
			end
		end
	else
		if obj.isA and obj:isA("baseClass") then
			table.insert(controller.selection, obj)
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

return controller