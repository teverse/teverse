-- Copyright (c) 2019 teverse.com

local hotkeysController = {
	bindings = {}
}

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
    
    return hotkeyData.action 
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

return hotkeysController