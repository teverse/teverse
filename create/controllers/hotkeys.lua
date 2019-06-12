


local hotkeysController = {

	clipboard = {},
	bindings = {}

}

local selectionController = require("tevgit:create/controllers/select.lua")

function hotkeysController:bind(hotkeyData)
	
	if (hotkeyData.priorKey) then
		if (not self.bindings[hotkeyData.priorKey]) then
			self.bindings[hotkeyData.priorKey] = {}
		end
		if (self.bindings[hotkeyData.priorKey][hotkeyData.key]) then
			error("Hot key " .. hotkeyData.name .. " can not overwrite existing hotkey: " .. self.bindings[hotkeyData.priorKey][hotkeyData.key].name)
		end
		self.bindings[hotkeyData.priorKey][hotkeyData.key] = hotkeyData
	else
		if (self.bindings[hotkeyData.key]) then
			error("Hot key " .. hotkeyData.name .. " can not overwrite existing hotkey: " .. self.bindings[hotkeyData.key].name)
		end
		self.bindings[hotkeyData.key] = hotkeyData
	end

	print("Successfully binded hotkey " .. hotkeyData.name)

end

function hotkeysController:handle(inputObject)

	for key, data in pairs(self.bindings) do
		if (not data.action) then
			if (engine.input:isKeyDown(key)) then 
				for key, data in pairs(data) do 
					if (inputObject.key == key) then 
						data.action()
						return 
					end 
				end 
			end 
		else 
			if (inputObject.key == key) then
				data.action()
				return
			end
		end 
	end

end

engine.input:keyPressed(function(inputObject)
	if (inputObject.systemHandled) then 
		return
	else 
		hotkeysController:handle(inputObject)
	end
end)

hotkeysController:bind({
	name = "delete",
	key = enums.key.delete,
	action = function()
		local objects = selectionController.selection
		selectionController.setSelection({})
		for _, object in pairs(objects) do
			if (object) then
				object:destroy()
			end
		end
	end
})

hotkeysController:bind({
	name = "clone",
	priorKey = enums.key.leftCtrl,
	key = enums.key.c, 
	action = function()
		hotkeysController.clipboard = selectionController.selection
	end
})

hotkeysController:bind({
	name = "paste",
	priorKey = enums.key.leftCtrl,
	key = enums.key.v, 
	action = function()
		local newItems = {}
		local size, pos = selectionController.calculateBounding(hotkeysController.clipboard)
		for _,v in pairs(hotkeysController.clipboard) do
			if v then
				v.emissiveColour = colour(0,0,0)
				local new = v:clone()
				new.position = v.position + vector3(0,size.y,0)
				table.insert(newItems, new)
			end
		end
		selectionController.setSelection(newItems)
	end
})

hotkeysController:bind({
	name = "duplicate",
	priorKey = enums.key.leftCtrl,
	key = enums.key.x, 
	action = function()
		hotkeysController.clipboard = selectionController.selection
		local newItems = {}
		for _,v in pairs(hotkeysController.clipboard) do
			if v then
				v.emissiveColour = colour(0,0,0)
				local new = v:clone()
				table.insert(newItems, new)
			end
		end
		selectionController.setSelection(newItems)
	end
})

return hotkeysController