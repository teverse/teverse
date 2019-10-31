--[[ 
    The history ui window is managed in another module

    Example Usuage:
    local history = require(thismodule)
    
    local selection = {obj1, obj2}
    history.beginAction(selection, "testAction")
    
    obj1.colour = colour:random()
    something(obj2)

    history.endAction()

]]

local limit = 100 -- how many actions can we store

local shared = require("tevgit:workshop/controllers/shared.lua")

local pointer = limit
local actions = {}

-- used internally to prevent unfinished actions
local actionInProgress = false

local callback = nil

-- Used to track changes during an action
local changes = {}
local eventListeners = {}
local actionName = ""
-- oldValue added to changed event from "POTATO 0.7.0"
local function changedListener(property, value, oldValue)
    local changedObject = self.object
    if not changes[changedObject] then
        changes[changedObject] = {}
    end 
    
    if not changes[changedObject][property] then
        changes[changedObject][property] = {oldValue, value}
    else
        -- do not change the old value, we've already recorded it.
        changes[changedObject][property][2] = value 
    end
end

local function destroyingListener()
    local changedObject = self.object
    if not changes[changedObject] then
        changes[changedObject] = {}
    end 
    
    changes[changedObject]["_destroyed"] = true
end

local function count(dictionary)
    local i = 0
    for _,v in pairs(dictionary) do i = i + 1 end
    return i
end

-- Tell this module that we're about to change some things
-- the module will register changed callbacks to record the before/after
--
-- object : table of teverse objects or teverse object
-- name : name of the event/action
--
-- you need to call endAction after completing your changes to the objects
local function beginAction( object, name )
    assert(not actionInProgress, "please use endAction before starting another")
    actionInProgress = true
    actionName = name or ""
    if type(object) == "table" then
        for _,v in pairs(object) do
            table.insert(eventListeners, v:onSync("changed", changedListener))
            table.insert(eventListeners, v:onSync("destroying", destroyingListener))
        end
    else
        table.insert(eventListeners, object:onSync("changed", changedListener))
        table.insert(eventListeners, object:onSync("destroying", destroyingListener))
    end
end

local function endAction()
    assert(actionInProgress, "you must call beginAction first")

    -- stop listening to the objects
    for _,v in pairs(eventListeners) do
        v:disconnect()
    end
    eventListeners = {}

    pointer = pointer + 1
    if pointer >= limit then
        pointer = 0 -- wrap back around to the beginning of the table
    end

    actions[pointer] = {actionName, changes}
    changes = {}

    print("Objects Changed: ", count(actions[pointer][2]))

    actionInProgress = false

    if type(callback) == "function" then
        callback()
    end
end

return {
    beginAction = beginAction,
    endAction = endAction,

    getActions = function() return actions end,
    getPointer = function() return pointer end,
    limit = limit,

    setCallback = function (cb)
        callback = cb
    end,

    count = count
}