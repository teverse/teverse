-- Copyright (c) 2019 teverse.com
-- select.lua

local selectionController = {}

selectionController.selectable = true

selectionController.boundingBoxListeners = {}
selectionController.selection = {}

selectionController.removeBoundingListener = function(v)

end

selectionController.addBoundingListener = function(v)

end

selectionController.calculateBoundingBox = function()

end

engine.input:mouseLeftPressed(function(inp)
    if not inp.systemHandled and selectionController.selectable then
        local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
	    if not mouseHit or mouseHit.object.workshopLocked then
    		if mouseHit and mouseHit.object.name == "_CreateMode_" then return end -- dont deselect
    		-- User clicked empty space, deselect everything??#
    		for _,v in pairs(selectionController.selection) do
    			v.emissiveColour = colour(0.0, 0.0, 0.0)
    		end
    		selectionController.selection = {}

    		for _,v in pairs(selectionController.boundingBoxListeners) do
    			v:disconnect()
    		end
    		
    		selectionController.boundingBoxListeners = {}

    		selectionController.calculateBoundingBox()
    		return
    	end

    	local doSelect = true

    	if not engine.input:isKeyDown(enums.key.leftShift) then
    		-- deselect everything that's already selected and move on
    		for _,v in pairs(selectionController.selection) do
    			v.emissiveColour = colour(0.0, 0.0, 0.0)
    		end
    		selectionController.selection = {}

    		for _,v in pairs(selectionController.boundingBoxListeners) do
    			v:disconnect()
    		end
    		selectionController.boundingBoxListeners = {}

    		selectionController.calculateBoundingBox()
    	else
    		for i,v in pairs(selectionController.selection) do
    			if v == mouseHit.object then
    				table.remove(selectionController.selection, i)
    				selectionController.removeBoundingListener(v)
    				v.emissiveColour = colour(0.0, 0.0, 0.0)
    				doSelect = false
    			end
    		end
    	end

    	if doSelect then

    		mouseHit.object.emissiveColour = colour(0.025, 0.025, 0.15)

    		table.insert(selectionController.selection, mouseHit.object)
    		selectionController.addBoundingListener(mouseHit.object)
    		selectionController.calculateBoundingBox()

    	end

    end
end)

return selectionController
