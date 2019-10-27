-- Selection Controller is incharge of storing and managing the user’s selection 

local controller = {}

controller.selection = {}

controller.setSelection = function(obj)
	controller.selection = {}
	controller.addSelection(obj)
end

controller.addSelection = function(obj)
	if type(obj) == "table" then
		for _,v in pairs(controller.selection) do
			controller.selection[v] = true
		end
	else
		controller.selection[obj] = true
	end
end

controller.isSelected = function(obj)
	return controller.selection[obj] ~= null
end

return controller