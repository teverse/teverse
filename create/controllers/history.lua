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

local workshop

function getWorkshop (ws)
    workshop = ws
end

-- TODO: Add support for combined actions (i.e. move multiple items at once)
-- TODO: Add buttons
-- TODO: Improve stability

-- HISTORY_CREATED, HISTORY_DELETED: When something is created or deleted the prop will be set to one of these.
-- These are named this way to make sure they'll never collide will real props (they never will: underscores are evil - jay)

-- We only store what is changed
function addUndo (object, changedProp, value)
    if changedProp == "HISTORY_DELETED" then
        -- Copy properties
        if object.alive and object.parent and object.parent.alive then
            local toStore = cloneObject(object)
            undoList[pointer] = {
                className = object.className,
                prop = changedProp,
                value = toStore
            }

        else
            return print("Can't add destroyed object to history")
        end
    else

        undoList[pointer] = {
            obj = object,
            prop = changedProp,
            value = value
        }
    end

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
        if point.prop == "HISTORY_CREATED" then
            print("removing created")
            -- To undo it we delete it. We should also copy the properties in-case it was a copy.
            local toStore = cloneObject(point.obj)
            local parent = point.obj.parent

            addRedo(point.obj.className, "HISTORY_CREATED", toStore)
            point.obj:destroy()

        elseif point.prop == "HISTORY_DELETED" then
            local parent = point.value.parent
            if parent then
                local object = engine.construct(point.className, parent, point.value)
                addRedo(object, "HISTORY_DELETED")
            else
                print("Failed to undo deletion: Parent no longer exists.")
            end


        else
            print("undoing "..point.prop)
            -- Normal: it hasn't been deleted.
            if point.obj and point.obj.alive then
                local object = point.obj
                -- not destroyed; reset value to prev & take redo value
                local redoValue = object[point.prop]
                addRedo(object, point.prop, redoValue)

                -- Restore value
                object[point.prop] = point.value
            end

        end

        local object = point.obj
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
        if point.prop == "HISTORY_CREATED" then
            -- To redo it we create it. We should have the properties

            local object = engine.construct(point.obj, point.value.parent, point.value)
            addUndo(object, "HISTORY_CREATED")

        elseif point.prop == "HISTORY_DELETED" then
            if not point.obj then print("ERROR: Object does not exist.")
                addUndo(point.obj, "HISTORY_DELETED")
                point.obj:destroy()
            else
                local object = point.obj

                if object and object.alive then
                    -- not destroyed; reset value to prev & take redo value
                    local redoValue = object[point.prop]
                    addUndo(object, point.prop, redoValue)

                    -- Restore value
                    object[point.prop] = point.value
                end
            end

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


function cloneObject (object)
    local members = workshop:getMembersOfObject( object )
    local toStore = {}
    for _, prop in pairs(members) do
        local val = object[prop.property]
        local pType = type(val)

        if prop.writable and pType ~= "function" then
            -- We can save it and re-construct it
            toStore[prop.property] = val
        end
    end
    toStore["parent"] = object.parent
    return toStore
end


return {
    addPoint = addUndo,
    undo = restorePoint,
    redo = redoAction,
    giveWorkshop = getWorkshop
}
