--[[
    Copyright 2019 Teverse
    @File history.lua
    @Author(s) Neztore
--]]


-- Manages undo/redo points. A stack type thing so we don't guzzle memory.
-- Config
local undoSize = 50
local redoSize = 20

-- Lists are stack like, but they fill up to 50 and then return to the start and just overwrite previous points.
local pointer = 0
local undoList = {}

local redoPointer = 0
local redoList = {}

-- TODO: Add special (i.e. deletion or creation) support
-- TODO: Add support for combined actions (i.e. move multiple items at once)
-- TODO: Add keybinds
-- TODO: Add buttons
-- HISTORY_CREATED, HISTORY_DELETED: When something is created or deleted the prop will be set to one of these.
-- These are named this way to make sure they'll never collide will real props

-- We only store what is changed
function addUndo (object, changedProp, value)
    print("Undo point added!")
    undoList[pointer] = {
        obj = object,
        prop = changedProp,
        value = value
    }

    if pointer >= undoSize then
        -- We return to start and start overwriting.
        pointer = 0
    else
        pointer = pointer + 1
    end
end

-- Restores the last point on the list
function restorePoint ()
    if pointer == 0 then
        if undoList[undoSize] then
            -- The last item exists, so we just go to back. We go to 1+ to account for pointer problems.
            pointer = undoSize + 1
        end
    end

    local point = undoList[pointer - 1]
    if point then
        local object = point.obj

        if object and object.alive then
            -- not destroyed; reset value to prev & take redo value
            local redoValue = object[point.prop]
            addRedo(object, point.prop, redoValue)

            -- Restore value
            object[point.prop] = point.value
        end


        undoList[pointer - 1] = nil
        pointer = pointer - 1
    else
        print("Nothing left to undo!")
    end

end

-- "Redoes" the last action.
function addRedo (object, changedProp, value)
    redoList[redoPointer] = {
        obj = object,
        prop = changedProp,
        value = value
    }
    if redoPointer >= redoSize then
        -- We return to start and start overwriting.
        redoPointer = 0
    else
        redoPointer = redoPointer + 1
    end
end

-- Opposite of restorePoint
function redoAction ()
    if redoPointer == 0 then
        if redoList[redoSize] then
            -- The last item exists, so we just go to back. We go to 1+ to account for pointer problems.
            redoPointer = redoSize + 1
        end
    end

    local point = redoList[redoPointer - 1]

    if point then
        local object = point.obj

        if object and object.alive then
            -- not destroyed; reset value to prev & take redo value
            local redoValue = object[point.prop]
            addUndo(object, point.prop, redoValue)

            -- Restore value
            object[point.prop] = point.value
        end


        redoList[redoPointer - 1] = nil
        redoPointer = redoPointer - 1
        -- We return so buttons etc. know if it's empty.
        return true
    else
        print("Nothing left to redo!")
        return false
    end
end


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end



return {
    addPoint = addUndo,
    undo = restorePoint,
    redo = redoAction
}
