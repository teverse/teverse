-- Copyright 2019 Teverse
-- Select tool

local toolName = "Add"
local toolIcon = "fa:s-plus"
local toolDesc = "Use this to insert shapes."
local toolController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")

local active = false

local toolActivated = function(id)
    --create interface
    --access tool data at toolsController.tools[id].data
    selectionController.selectable = false
    
    active = true
    
    toolsController.tools[id].data.placeholderBlock = engine.construct("block", nil, {
        name = "_CreateMode_add_tool_placeholder",
        size = vector3(2, 2, 2),
        static = true,
        physics = false,
        castsShadows = false        
    })
    
    while active and wait() do
        local mouseHit = engine.physics:rayTestScreen( engine.input.mousePosition )
        if mouseHit then
            placeholderBlock.position = mouseHit.hitPosition
        end
    end
    
end

local toolDeactivated = function(id)
    selectionController.selectable = true
    
    toolsController.tools[id].data.placeholderBlock:destroy()
    toolsController.tools[id].data.placeholderBlock = nil
    
    active = false
end

return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
