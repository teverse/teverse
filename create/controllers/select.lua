-- Copyright (c) 2019 teverse.com
-- select.lua

local selectionController = {}

selectionController.selectable = true

selectionController.boundingBox = engine.construct("block", nil, {
	name = "_CreateMode_boundingBox",
	wireframe = true,
	castsShadows = false,
	static = true,
	physics = false, 
	colour = colour(1, 0.8, 0.8),
	opacity = 0,
	size = vector3(0, 0, 0)
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

function calculateVertices(block)
	local vertices = {}
	for x = -1,1,2 do
		for y = -1,1,2 do
			for z = -1,1,2 do
				table.insert(vertices, block.position + block.rotation* (vector3(x,y,z) *block.size/2))
			end
		end
	end
	return vertices
end

selectionController.calculateBounding = function(items)

        local min, max;

                for _,v in pairs(items) do
                    if not min then min = v.position; max=v.position end
                    local vertices = calculateVertices(v)
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

    		mouseHit.object.emissiveColour = colour(0.025, 0.025, 0.15)

    		table.insert(selectionController.selection, mouseHit.object)
    		selectionController.addBoundingListener(mouseHit.object)
    		selectionController.calculateBoundingBox()

    	end

    end
end)

return selectionController
