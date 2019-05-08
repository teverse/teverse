


--[[
    Copyright 2019 Teverse
    @File add.lua
    @Author(s) Jay, Ly
    @Updated 5/8/19
--]]

TOOL_NAME = "Add"
TOOL_ICON = "fa:s-plus-square"
TOOL_DESCRIPTION = "Use this to insert shapes."

local toolController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")

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
    end
    
    tool.data.mouseDownEvent = engine.input:mouseLeftPressed(function()
        placeBlock()
        local curTime = os.clock()
        mouseDown = curTime
        wait(0.2) 
        if (mouseDown == curTime) then
            while (wait(.05)) and (mouseDown == curTime and toolController.currentToolId == toolId) do
                placeBlock()
            end
        end
    end)

    tool.data.mouseUpEvent = engine.input:mouseLeftReleased(function()
        mouseDown = 0
    end)
    
    while (toolIsActive and wait()) do
        local mouseHit = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, tool.data.placeholderBlock)
        if #mouseHit > 0 then
            tool.data.placeholderBlock.position = mouseHit[1].hitPosition + vector3(0, 0.5, 0)
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

    selectionController.selectable = true
    local tool = toolsController.tools[toolId]
    
    tool.data.mouseDownEvent:disconnect()
    tool.data.mouseDownEvent = nil
    tool.data.mouseUpEvent:disconnect()
    tool.data.mouseUpEvent = nil
    
    tool.data.placeholderBlock:destroy()
    tool.data.placeholderBlock = nil
    
    toolIsActive = false

end

return toolController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    activated = onToolActivated,
    deactivated = onToolDeactviated

})


