-- Copyright (c) 2019 teverse.com
-- select.lua

local selectionController = {}

selectionController.selectable = true

local propertyEditor  = require("tevgit:create/controllers/propertyEditor.lua")
local lights  = require("tevgit:create/controllers/lights.lua")
local helpers  = require("tevgit:create/helpers.lua")

selectionController.boundingBox = engine.construct("block", nil, {
	name = "_CreateMode_boundingBox",
	wireframe = true,
	castsShadows = false,
	static = true,
	physics = false, 
	colour = colour(1, 0.8, 0.8),
	opacity = 0,
	size = vector3(0, 0, 0),
    doNotSerialise=true
})

selectionController.boundingBoxListeners = {}
selectionController.selection = {}

selectionController.removeBoundingListener = function(block)
	for i,v in pairs(selectionController.boundingBoxListeners) do
		if v[1] == block then
			selectionController.boundingBoxListeners[i] = nil
			return nil
		end
	end
end

selectionController.addBoundingListener = function(block)
	table.insert(selectionController.boundingBoxListeners, {block, block:changed(selectionController.calculateBoundingBox)})
end


selectionController.calculateBounding = function(items)

        local min, max;

                for _,v in pairs(items) do
                    if not min then min = v.position; max=v.position end
                    local vertices = helpers.calculateVertices(v)
                    for i,v in pairs(vertices) do
                        min = min:min(v)
                        max = max:max(v)
                    end
                end

        return (max-min), (max - (max-min)/2)
end

local isCalculating = false
selectionController.calculateBoundingBox = function ()
    if isCalculating then return end
    isCalculating=true
    

    if #selectionController.selection < 1 then
        selectionController.boundingBox.size = vector3(0,0,0)
        selectionController.boundingBox.opacity = 0
        isCalculating = false
    return end

    selectionController.boundingBox.opacity = 0.5

    local size, pos = selectionController.calculateBounding(selectionController.selection)
    selectionController.boundingBox.size = size
    selectionController.boundingBox.position = pos

    --engine.tween:begin(boundingBox, .025, {size = max-min, position = max - (max-min)/2}, "inQuad")

    isCalculating = false
end

engine.input:mouseLeftReleased(function(inp)
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
    			v[2]:disconnect()
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
    			v[2]:disconnect()
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

            if type(mouseHit.object) == "block" and mouseHit.object.name ~= "_CreateMode_Light_Placeholder" then
        		mouseHit.object.emissiveColour = colour(0.025, 0.025, 0.15)
            end

    		table.insert(selectionController.selection, mouseHit.object)
    		selectionController.addBoundingListener(mouseHit.object)
    		selectionController.calculateBoundingBox()

            if mouseHit and mouseHit.object.name == "_CreateMode_Light_Placeholder" then
                if lights.lights[mouseHit.object] then
                    --ignore the block they pressed, they clicked a light
                    propertyEditor.generateProperties(lights.lights[mouseHit.object])
                    return
                end
            end

			propertyEditor.generateProperties(mouseHit.object)
    	end

    end
end)

selectionController.setSelection = function (selection)
    for _,v in pairs(selectionController.selection) do
        v.emissiveColour = colour(0.0, 0.0, 0.0)
    end

    for _,v in pairs(selectionController.boundingBoxListeners) do
        v[2]:disconnect()
    end
    selectionController.boundingBoxListeners = {}
    selectionController.selection = {}

    for _,v in pairs(selection) do
        v.emissiveColour = colour(0.025, 0.025, 0.15)
        table.insert(selectionController.selection, v)
        selectionController.addBoundingListener(v)
    end

    if (#selection > 0) then
        propertyEditor.generateProperties(selection[1])
    end

    selectionController.calculateBoundingBox()
end

return selectionController
