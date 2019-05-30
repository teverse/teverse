local controller = {}
local uiController = require("tevgit:create/controllers/ui.lua")

print("Sandbox Test, this should be removed later: ", engine, engine.workshop)

controller.window = nil

function controller.createUI(workshop)
	local controller.window = uiController.create("guiFrame", workshop.interface, {
		name = "propertyWindow",
		draggable = true,
		size = guiCoord(0.25, 0, 0.5, 0),
		position = guiCoord(0.75, 0, 0.5, 0)
	}, "main")
end

controller.createInput = {
	default = function(value, pType, readOnly)
		print("Default handler to create input for " .. ptype)
	end
}

local function alphabeticalSorter(a, b)
	return a.property < b.property
end

function controller.generateProperties(instance)
    if instance and instance.events and instance.events["changed"] then
        local members = engine.workshop:getMembersOfInstance( instance )
        table.sort( members, alphabeticalSorter ) 
       	
       	-- unsure if destroyallchildren is implemented on this instance
       	for _,v in pairs(controller.window.children) do
       		v:destroy()
       	end
       	
       	local y = 0
       	
        for i, v in pairs(members) do
            local value = instance[v.property]
            local pType = type(value)
            local readOnly = not v.writable
            
            if pType ~= "function" then
            	local label = uiController.create("guiTextBox", controller.window, {
            		name = "label" .. v.property,
            		size = guiCoord(0.5, 0, 0, 18),
            		position = guiCoord(0,0,0,y)
            		fontSize = 18,
            		text = v.property
            	}, "main")
            	
            	if controller.createInput[pType] then
            		controller.createInput[pType](value,pType, readOnly)
            	else
            		controller.createInput.default(value, pType, readOnly)
            	end
            	
            	y = y + 18
            end
        end
    end
end

return controller