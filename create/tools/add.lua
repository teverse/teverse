--add.lua
-- Copyright 2019 Teverse

local toolName = "Add"
local toolIcon = "fa:s-plus-square"
local toolDesc = "Use this to insert shapes."
local toolController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")

local active = false

local toolActivated = function(id)
    --create interface
    --access tool data at toolsController.tools[id].data
    selectionController.selectable = false
    
    active = true
    
    toolController.tools[id].data.placeholderBlock = engine.construct("block", nil, {
        name = "_CreateMode_add_tool_placeholder",
        size = vector3(1, 1, 1),
        static = true,
        physics = false,
        castsShadows = false        
    })
    
    toolController.tools[id].data.mouseDownEvent = engine.input:mouseLeftPressed(function ( inp )
        local newBlock = toolController.tools[id].data.placeholderBlock:clone()
        newBlock.name = "newBlock"
        newBlock.workshopLocked = false
        newBlock.parent = engine.workspace
        newBlock.physics = true
    end)
    
    while active and wait() do
        local mouseHit = engine.physics:rayTestScreenAllHits( engine.input.mousePosition, toolController.tools[id].data.placeholderBlock )
        if #mouseHit > 0 then
            toolController.tools[id].data.placeholderBlock.position = mouseHit[1].hitPosition + vector3(0, 0.5, 0)
        end
    end
    
end

local toolDeactivated = function(id)
    selectionController.selectable = true
    
    toolController.tools[id].data.mouseDownEvent:disconnect()
    toolController.tools[id].data.mouseDownEvent = nil
    
    toolController.tools[id].data.placeholderBlock:destroy()
    toolController.tools[id].data.placeholderBlock = nil
    
    active = false
end

return toolController.add(toolName, toolIcon, toolDesc, toolActivated, toolDeactivated)
