local controller = {}
local uiController = require("tevgit:create/controllers/ui.lua")

controller.window = nil
controller.workshop = nil

function controller.createUI(workshop)
  controller.workshop = workshop
	controller.window = uiController.create("guiFrame", workshop.interface, {
		name = "propertyWindow",
		draggable = true,
		size = guiCoord(0.25, 0, 0.5, 0),
		position = guiCoord(0.75, 0, 0.5, 0)
	}, "main")
end

controller.createInput = {
	default = function(value, pType, readOnly)
		return engine.construct("guiFrame", nil, {
			guiStyle = enums.guiStyle.noBackground,
			size = guiCoord(0.5, 0, 0, 18)
		})
	end
}

local function alphabeticalSorter(a, b)
	return a.property < b.property
end

function controller.generateProperties(instance)
    if instance and instance.events and instance.events["changed"] then
        local members = controller.workshop:getMembersOfInstance( instance )
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
            		position = guiCoord(0,0,0,y),
            		fontSize = 18,
            		text = v.property
            	}, "main")

              local inputGui = nil
            	
            	if controller.createInput[pType] then
            		inputGui = controller.createInput[pType](value,pType, readOnly)
            	else
            		inputGui = controller.createInput.default(value, pType, readOnly)		
            	end
            	
              inputGui.position = guiCoord(0.5, 0, 0, y)
              inputGui.parent = controller.window

            	y = y + 18
            end
        end
    end
end

return controller