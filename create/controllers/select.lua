-- Copyright (c) 2019 teverse.com
-- select.lua

local selectionController = {

	selectable = true,
	clipboard = {},
	selection = {},
	boundingBoxListeners = {},

	boundingBox = engine.construct("block", nil, {
		name = "_CreateMode_boundingBox",
		wireframe = true,
		castsShadows = false,
		static = true,
		physics = false, 
		colour = colour(1, 0.8, 0.8),
		opacity = 0,
		size = vector3(0, 0, 0),
		doNotSerialise = true
	})

}

local hotkeys		  = require("tevgit:create/controllers/hotkeys.lua")
local contextMenu 	  = require("tevgit:create/controllers/contextMenu.lua")
local propertyEditor  = require("tevgit:create/controllers/propertyEditor.lua")
local lights          = require("tevgit:create/controllers/lights.lua")
local helpers         = require("tevgit:create/helpers.lua")
local history 		  = require("tevgit:create/controllers/history.lua")

local isCalculating = false

local function clearSelectedObjectsInClipboard()
	for _, object in pairs(selectionController.selection) do
		for index, object2 in pairs(selectionController.clipboard) do
			if (object == object2) then
				selectionController.clipboard[index] = nil
			end
		end
	end
end

function selectionController.copySelection()
	selectionController.clipboard = selectionController.selection
end

function selectionController.pasteSelection(keepPosition)
	local selection = {}
	local clipboard = selectionController.clipboard
	local size, pos = selectionController.calculateBounding(clipboard)
	for _, object in pairs(clipboard) do
		if (object) then
			if (not helpers.startsWith(object.name, "_CreateMode_")) then 
				history.addPoint(object, "HISTORY_CREATED")
				object.emissiveColour = colour()
				local clone = object:clone()
				clone.parent = workspace 
				if (not keepPosition) then 
					clone.position = object.position + vector3(0, size.y, 0)
				end
				table.insert(selection, clone)
			elseif (lights.lights[object]) then
				local light = lights.lights[object]
				history.addPoint(light, "HISTORY_CREATED")
				local clone = light:clone()
				clone.shadows = false
				clone.parent = workspace
				if (not keepPosition) then
					clone.position = light.position + vector3(0,1,0)
				else
					clone.position = light.position
				end
			end
		end
	end

	selectionController.setSelection(selection)
	print("Pasted selection", selection)
	--[[for _,v in pairs(hotkeysController.clipboard) do
		if v and v.name ~= "_CreateMode_Light_Placeholder" then
			history.addPoint(v, "HISTORY_CREATED")
			v.emissiveColour = colour(0,0,0)
			local new = v:clone()
			new.parent = workspace
			new.position = v.position + vector3(0,size.y,0)
			table.insert(newItems, new)
		elseif v then
			--copying a light
			local light = require("tevgit:create/controllers/lights.lua").lights[v]
			if light then
				history.addPoint(light, "HISTORY_CREATED")
				local new = light:clone()
				new.shadows = false -- purely a performance boost.
				new.parent = workspace
				new.position = light.position + vector3(0,1,0)
			   -- table.insert(newItems, new)
			end
		end
	end
	selectionController.setSelection(newItems)]]	
end

function selectionController.deleteSelection()
	local objects = selectionController.selection
	clearSelectedObjectsInClipboard()
	selectionController.setSelection({})
	if(objects[1].parent:isA("folder")) then
		history.addPoint(objects[1].parent, "HISTORY_DELETED")
		objects[1].parent:destroy()
	else
		for _, object in pairs(objects) do
			if (object) then
				history.addPoint(object, "HISTORY_DELETED")
				object:destroy()
			end
		end
	end
end

function selectionController.duplicateSelection()
	selectionController.copySelection()
	selectionController.pasteSelection(true)
end

function selectionController.deselectSelection()
	selectionController.setSelection({})
end

function selectionController.groupSelection()
	if (#selectionController.selection > 1) then
		local selection = selectionController.selection
		local folder = engine.folder("group")
		folder.parent = workspace
		for _, object in pairs(selection) do object.parent = folder end
		propertyEditor.generateProperties(folder)
	end
end

function selectionController.ungroupSelection()
	if (#selectionController.selection > 1) then
		local parent = selectionController.selection[1].parent
		if (parent:isA("folder")) then
			for _, object in pairs(parent.children) do object.parent = parent.parent  end
			propertyEditor.generateProperties(selectionController.selection[1])
			parent:destroy()
		end
	end
end

function selectionController.removeBoundingListener(block)
	for i,v in pairs(selectionController.boundingBoxListeners) do
		if v[1] == block then
			selectionController.boundingBoxListeners[i] = nil
			return nil
		end
	end
end

function selectionController.addBoundingListener(block)
	table.insert(selectionController.boundingBoxListeners, { block, block:changed(selectionController.calculateBoundingBox) })
end

function selectionController.calculateBounding(items)
	local min, max;
	for _,v in pairs(items) do
		if type(v) == "block" then
			if v and v.alive then
				if not min then min = v.position; max=v.position end
				local vertices = helpers.calculateVertices(v)
				for i,v in pairs(vertices) do
					min = min:min(v)
					max = max:max(v)
				end
			end
		end
	end
	if max ~= nil and min ~= nil then
		return (max-min), (max - (max-min)/2)
	end
end

function selectionController.calculateBoundingBox()
    if isCalculating then return end
    isCalculating = true
    

    if #selectionController.selection < 1 then
        selectionController.boundingBox.size = vector3(0,0,0)
        selectionController.boundingBox.opacity = 0
        isCalculating = false
		return 
	end

    selectionController.boundingBox.opacity = 0.5

    local size, pos = selectionController.calculateBounding(selectionController.selection)
	if size and pos then
		selectionController.boundingBox.size = size
		selectionController.boundingBox.position = pos
	end

    --engine.tween:begin(boundingBox, .025, {size = max-min, position = max - (max-min)/2}, "inQuad")

    isCalculating = false
end

function selectionController.setSelection(selection)
    for _,v in pairs(selectionController.selection) do
        if type(v) == "block" then
            v.emissiveColour = colour(0.0, 0.0, 0.0)
        end
    end

    for _,v in pairs(selectionController.boundingBoxListeners) do
        v[2]:disconnect()
    end
    selectionController.boundingBoxListeners = {}
    selectionController.selection = {}

    for _,v in pairs(selection) do
        if type(v) == "block" then
            v.emissiveColour = colour(0.025, 0.025, 0.15)
            selectionController.addBoundingListener(v)
        end
        table.insert(selectionController.selection, v)
    end

    if (#selection > 0) then
        propertyEditor.generateProperties(selection[1])
    end

    selectionController.calculateBoundingBox()
end

function selectionController.isSelected(object)
    for _,v in pairs(selectionController.selection) do
        if v == object then 
            return true
        end
    end
end

engine.input:mouseLeftReleased(function(input)
    if not input.systemHandled and selectionController.selectable then
        local mouseHit = engine.physics:rayTestScreen(engine.input.mousePosition)
	    if not mouseHit or mouseHit.object.workshopLocked then
    		if mouseHit and mouseHit.object.name == "_CreateMode_" then return end -- dont deselect

    		-- User clicked empty space, deselect everything??#
    		for _,v in pairs(selectionController.selection) do
                if type(v) == "block" then
    				if v and v.alive then
    					v.emissiveColour = colour(0.0, 0.0, 0.0)
    				else
    					print("Cannot change emissiveColour: Object deleted.")
    				end
                end

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
                if type(v) == "block" then
        			v.emissiveColour = colour(0.0, 0.0, 0.0)
                end
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

			if (mouseHit.object.parent:isA("folder")) then
				selectionController.setSelection(mouseHit.object.parent.children)
				propertyEditor.generateProperties(mouseHit.object.parent)
			else
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
            

    end
end)


-- @hotkeys Copy, paste, & duplicate
hotkeys:bind({ name = "copy", priorKey = enums.key.leftCtrl, key = enums.key.c, action =selectionController.copySelection })
hotkeys:bind({ name = "paste", priorKey = enums.key.leftCtrl, key = enums.key.v, action =selectionController.pasteSelection })
hotkeys:bind({ name = "duplicate", priorKey = enums.key.leftCtrl, key = enums.key.d, action =selectionController.duplicateSelection })

-- @hotkeys Delete, deselect, group & TBA ungroup
hotkeys:bind({ name = "delete", key = enums.key.delete, action =selectionController.deleteSelection })
hotkeys:bind({ name = "deselect", key = enums.key.escape, action = selectionController.deselectSelection })
hotkeys:bind({ name = "group", priorKey = enums.key.leftCtrl, key = enums.key.g, action =selectionController.groupSelection })

-- @hotkey Focus selection
local function focusSelection()
	if (#selectionController.selection > 0) then
		local mdn = vector3(helpers.median(selectionController.selection, "x"), helpers.median(selectionController.selection, "y"), helpers.median(selectionController.selection, "z") )
		engine.tween:begin(workspace.camera, .2, { position = mdn + (workspace.camera.rotation * vector3(0,0,1) * 15) }, "outQuad")
	end
end
hotkeys:bind({
    name = "focus on selection",
    key = enums.key.f,
    action = focusSelection
})

-- @hotkey Select all
hotkeys:bind({
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

-- @section Context Menu
local function newBlockWrapper(mesh)
	return function()
		print("called")
		local mousePos = engine.input.mousePosition
		local mouseHit = engine.physics:rayTestScreen(mousePos)
		local block = engine.construct("block", workspace, {
			position = mouseHit.hitPosition,
			mesh = mesh 
		})
		print("new block")
	end
end

function selectionController.getContextOptions()
	local options = {
		new = {
			subOptions = {
				block = {
					action = newBlockWrapper()
				},
				sphere = {
					action = newBlockWrapper("primitive:sphere")
				},
				cone = {
					action = newBlockWrapper("primitive:cone")
				},
				wedge = {
					action = newBlockWrapper("primitive:wedge")
				}
			}
		}
	}
	if (#selectionController.selection > 0) then 
		options.copy = {
			hotkey = "ctrl + c",
			action = selectionController.copySelection
		}
		options.delete = {
			hotkey = "del",
			action = selectionController.deleteSelection
		}
		options.focus = {
			hotkey = "f",
			action = focusSelection
		}
		if (#selectionController.selection > 1) then
			if (selectionController.selection[1].parent:isA("folder")) then
				options.ungroup = {
					action = selectionController.ungroupSelection
				}
			else
				options.group = {
					hotkey = "ctrl + g",
					action = selectionController.groupSelection
				}
			end
		end
	end
	if (#selectionController.clipboard > 0) then
		options.paste = {
			hotkey = "ctrl + v",
			action = selectionController.pasteSelection
		}
		options.duplicate = {
			hotkey = "ctrl + d",
			action = selectionController.duplicateSelection
		}
	end 
	return options
end 

function selectionController.applyContext(object)
	return contextMenu.bind(object, selectionController.getContextOptions())
end

engine.input:mouseRightReleased(function(input)
	if ((not input.systemHandled) and (engine.physics:rayTestScreen(engine.input.mousePosition).object)) then
		contextMenu.display(contextMenu.create(selectionController.getContextOptions()))
	end
end)

return selectionController
