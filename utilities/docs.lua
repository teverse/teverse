--[[
    This contents of this script is used in our
    API dumps.
]]

local docs = {}
local function addDocs(class, d)
    docs[class] = d
end

local function property(desc)
    if not desc then desc = "No description was set" end
    return { description = desc }
end

local function method(desc, params, returns)
    if not desc then desc = "No description was set" end
    return { description = desc, parameters = params, returns = returns }
end

local function event(desc, params)
    if not desc then desc = "No description was set" end
    return { description = desc, parameters = params}
end

--------------- Docs Begin ---------------

addDocs("baseClass", {
    description = "The superclass of all Teverse classes",
    properties  = {
        name                        = property("A none unique identifier"),
        className                   = property("The name of the object's class"),
        id                          = property("A unique identifier used internally, use is not recommended as this may be nil"),
        children                    = property("A readonly table of child objects, a reference to this table will not remain up to date")
    },
    
    methods     = {
        destroy                     = method("Locks the object before removing it from the hierarchy. Children will also be destroyed."),
        destroyAllChildren          = method("Invokes the destroy method on each child of this instance."),
        isContainer                 = method("", nil, {
                                        "boolean"
                                     }),
        clone                       = method(),
        isA                         = method("Returns true if this object is derived from the className given.", {
                                        className = "string"
                                      }, {
                                        "boolean"
                                      }),
        hasChild                    = method(),
        isDescendantoF              = method(),
    },
    
    events      = {
        changed                     = event("Fired when a property changes", {
                                        propertyName = "string",
                                        newValue     = "variant"
                                      }),
        childAdded                  = event(),
        childRemoved                = event(),
        destroying                  = event(),
    }
})

addDocs("assets", {
    description = "Assets is a property of engine and is the main container for some of the core components of a game. Assets is a singleton that can be accessed via engine.assets. Children cannot be added to this class.",
    properties  = {
        lua                         = property("This Lua folder contains the luaServerFolder, luaClientFolder and luaSharedFolder"),
    },
})

return docs