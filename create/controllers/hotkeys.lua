


local hotkeysController = {

	clipboard = {},
	bindings = {}

}

local selectionController = require("tevgit:create/controllers/select.lua")
local toolsController = require("tevgit:create/controllers/tool.lua")
local themeController = require("tevgit:create/controllers/theme.lua")
local helpers = require("tevgit:create/helpers.lua")

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
                history.addPoint(object, "HISTORY_DELETED")
                object:destroy()
            end
        end
    end
})

hotkeysController:bind({
    name = "copy",
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
                history.addPoint(v, "HISTORY_CREATED")
                v.emissiveColour = colour(0,0,0)
                local new = v:clone()
                new.parent = workspace
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
    key = enums.key.d,
    action = function()
        hotkeysController.clipboard = selectionController.selection
        local newItems = {}
        for _,v in pairs(hotkeysController.clipboard) do
            if v then
                history.addPoint(v, "HISTORY_CREATED")

                v.emissiveColour = colour(0,0,0)
                local new = v:clone()
                new.parent = workspace
                table.insert(newItems, new)
            end
        end
        selectionController.setSelection(newItems)
    end
})

hotkeysController:bind({
    name = "deselect",
    key = enums.key.escape,
    action = function()
        -- it makes sense for escape to deselect selection...?
        selectionController.setSelection({})
    end
})

hotkeysController:bind({
    name = "focus on selection",
    key = enums.key.f,
    action = function()
        if #selectionController.selection > 0 then
            local mdn = vector3(helpers.median(selectionController.selection, "x"), helpers.median(selectionController.selection, "y"), helpers.median(selectionController.selection, "z") )
            engine.tween:begin(workspace.camera, .2, {position = mdn + (workspace.camera.rotation * vector3(0,0,1) * 15)}, "outQuad")
        end
    end
})


hotkeysController:bind({
    name = "select all",
    priorKey = enums.key.leftCtrl,
    key = enums.key.a,
    action = function()
        local selection = {}
        for _,v in pairs(workspace.children) do
            if not v.workshopLocked and type(v) == "block" then
                table.insert(selection, v)
            end
        end
        selectionController.setSelection(selection)
    end
})

-- Undo/redo so we don't need to require hotkeys in history.lua
hotkeysController:bind({
    name = "undo",
    priorKey = enums.key.leftCtrl,
    key = enums.key.z,
    action = history.undo
})

hotkeysController:bind({
    name = "redo",
    priorKey = enums.key.leftCtrl,
    key = enums.key.y,
    action = history.redo
})




return hotkeysController
