--[[
    Copyright 2019 Teverse
    @File add.lua
    @Author(s) Jay, Ly, joritochip
    @Updated 5/8/19
--]]

-- TODO: Create a UI that allows the user to select what primitive to insert
--       UI should also allow user to specify default values for the created primitives

TOOL_NAME = "Add"
TOOL_ICON = "fa:s-plus-square"
TOOL_DESCRIPTION = "Use this to insert shapes."

local toolsController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")
local propertyController  = require("tevgit:create/controllers/propertyEditor.lua")
local toolSettings  = require("tevgit:create/controllers/toolSettings.lua")
local helpers = require("tevgit:create/helpers.lua")

local toolIsActive

local function onToolActivated(toolId)
    
    --[[
        @Description
            Initializes the process (making placeholders & events) for placing blocks

        @Params
            Integer, toolId
                The unique {toolId} given after registering the tool
    ]]

    selectionController.selectable = false
    toolIsActive = true

    local tool = toolsController.tools[toolId]
    local mouseDown = 0
    
    tool.data.placeholderBlock = engine.construct(
        "block", 
        nil, 
        {
            name = "createModeAddToolPlaceholderObject",
            size = vector3(1, 1, 1),
            static = true,
            opacity = 0.5,
            physics = false,
            castsShadows = false        
        }
    )

    local function placeBlock()
        local newBlock = tool.data.placeholderBlock:clone()
        newBlock.name = "newBlock"
        newBlock.workshopLocked = false
        newBlock.opacity = 1
        newBlock.physics = true
        newBlock.castsShadows = true
        newBlock.parent = engine.workspace
        
        propertyController.generateProperties(newBlock)
    end
    
    tool.data.mouseDownEvent = engine.input:mouseLeftPressed(function(input)
		if input.systemHandled then return end 
		
        placeBlock()
        local curTime = os.clock()
        mouseDown = curTime
        wait(0.2) 
        if (mouseDown == curTime) then
            while (wait(.05)) and (mouseDown == curTime and toolsController.currentToolId == toolId) do
                placeBlock()
            end
        end
    end)

    tool.data.mouseUpEvent = engine.input:mouseLeftReleased(function(input)
		if input.systemHandled then return end 
		
        mouseDown = 0
    end)
    
    while (toolIsActive and wait() and tool.data.placeholderBlock) do
        local mouseHit = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, tool.data.placeholderBlock)
        if #mouseHit > 0 then
            tool.data.placeholderBlock.position = helpers.roundVectorWithToolSettings(mouseHit[1].hitPosition) + vector3(0, 0.5, 0)
        end
    end
    
end

local function onToolDeactviated(toolId)
    
    --[[
        @Description
            Clears up any loose ends during deactivation
        
        @Params
            Integer, toolId
                The unique {toolId} given after registering the tool
    ]]
    toolIsActive = false
    selectionController.selectable = true
    local tool = toolsController.tools[toolId]
    
    tool.data.mouseDownEvent:disconnect()
    tool.data.mouseDownEvent = nil
    tool.data.mouseUpEvent:disconnect()
    tool.data.mouseUpEvent = nil
    
    tool.data.placeholderBlock:destroy()
    tool.data.placeholderBlock = nil
end

return toolsController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    hotKey = enums.key.number1,

    activated = onToolActivated,
    deactivated = onToolDeactviated

})


