local controller = {}

local selectionController = require("tevgit:create/controllers/select.lua")

controller.clipboard = {}

engine.input:keyPressed(function (inputObj)
	if inputObj.systemHandled then return end

	if engine.input:isKeyDown(enums.key.leftCtrl) then
		if inputObj.key == enums.key.c then
			controller.clipboard = selectionController.selection
		elseif inputObj.key == enums.key.v then
			local newItems = {}

			local size, pos = selectionController.calculateBounding(controller.clipboard)

			for _,v in pairs(controller.clipboard) do
				if v then
					local new = v:clone()
					new.position = v.position + vector3(0,size.y,0)
					table.insert(newItems, new))
				end
			end
			selectionController.setSelection(newItems)
		end
	end
end)

return controller