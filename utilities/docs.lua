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
        getDescendants              = method("Returns a table of all descended objects", nil, {"table"})
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
        hasChild                    = method("Returns true if this object has a child with the name given", {
                                        name = "string"
                                    }, { "boolean" }),
        isDescendantOf              = method("Returns true if this object is a descendant of the ancestor object given", {
                                        ancestor = "baseClass"
                                    }, {"boolean"}),
        getFullName                 = method("Returns a string including ancestor names", nil, {"string"}),
        clone                       = method("Creates and returns a copy of this object", nil, {"variant"})
    },
    
    events      = {
        changed                     = event("Fired when a property changes", {
                                        propertyName = "string",
                                        newValue     = "variant",
                                        oldValue     = "variant"
                                      }),
        childAdded                  = event("Fired when a child is added", {
                                        child = "baseClass"
                                    }),
        childRemoved                = event("Fired when a child is removed", {
                                        child = "baseClass"
                                    }),
        destroying                  = event("Fired just before an object is destroyed."),
    }
})

addDocs("audioEmitter", {
    description = "",
    properties  = {
        position = property("Location of the sound in 3D space"),
        audioFile = property("The file that teverse will use to load sound, using [[resource locators]]."),
    },
    methods = {
        play = method("play the loaded audio file")
    }
})

addDocs("block", {
    description = "",
    properties  = {
        linearFactor = property("Restricts the linear movement in the physics engine. A value of (1,1,1) allows the object to move in all directions whereas (0,1,0) means the object can only move up and down on the y axis."),
        doNotSerialise = property("The built in game serialiser will not serialise objects with this set as true."),
        workshopLocked = property("Solely used in workshop"),
        meshScale = property("This is the value Teverse has had to scale the loaded mesh down in order to fit it in a 1x1x1 bounding box"),
        position = property("Location of the object in 3D space"),
        mesh = property("The file that teverse will use to load a 3d model, using [[resource locators]]."),
        physics = property("When true, things like raycasting may not work correctly for this object"),
        static = property("When true, this object will not move as it will become unaffected by forces including gravity."),
        opacity = property("A value of 1 indicates this object is not transparent.")
    },
    
    methods = {
        applyImpulseAtPosition = method("Applies an impulse force at a relative position to this object", {
            impulse = "vector3",
            position = "vector3"
        }),
        applyImpulse = method("Applies an impulse force to this object", {
            impulse = "vector3",
        }),
        applyForceAtPosition = method("Applies a force at a relative position to this object", {
            force = "vector3",
            position = "vector3"
        }),
        applyForce = method("Applies a force to this object", {
            force = "vector3",
        }),
        applyTorque = method("Applies a force to this object", {
            torque = "vector3",
        }),
        applyTorqueImpulse = method("Applies a force to this object", {
            torqueImpulse = "vector3",
        }),
        lookAt = method("Changes the objects rotation so that it is looking towards the provided position.", {
            position = "vector3",
        })
    }
})


addDocs("camera", {
    description = "",
    properties  = {
    
    },
    methods = {
        worldToScreen = method("Converts a 3d cooridinate into screenspace. Returns a bool indicating if the point is infront of the camera, returns a vector2 with the screenspace coordinates,", {
            position = "vector3"
        }, {"boolean", "vector2", "number"}),
        lookAt = method("Changes the objects rotation so that it is looking towards the provided position.", {
            position = "vector3",
        })
    }
})

return docs