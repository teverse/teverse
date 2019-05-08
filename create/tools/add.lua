


TOOL_NAME = "Add"
TOOL_ICON = "fa:s-plus-square"
TOOL_DESCRIPTION = "Use this to insert shapes."

local toolController = require("tevgit:create/controllers/tool.lua")
local selectionController = require("tevgit:create/controllers/select.lua")

local active = false

local toolActivated = function(toolId)
    
    selectionController.selectable = false
    active = true

    local tool = toolsController.tools[toolId]
    local mouseDown = 0
    
    tool.data.placeholderBlock = engine.construct("block", nil, {
        name = "_CreateMode_add_tool_placeholder",
        size = vector3(1, 1, 1),
        static = true,
        opacity = 0.5,
        physics = false,
        castsShadows = false        
    })

    local function placeBlock()
        local newBlock = tool.data.placeholderBlock:clone()
        newBlock.name = "newBlock"
        newBlock.workshopLocked = false
        newBlock.parent = engine.workspace
        newBlock.opacity = 1
        newBlock.physics = true
        newBlock.castsShadows = true
    end
    
    tool.data.mouseDownEvent = engine.input:mouseLeftPressed(function()
        placeBlock()
        local curTime = os.clock()
        mouseDown = curTime
        wait(0.2) 
        if mouseDown == curTime then
            while wait(.05) and mouseDown == curTime and toolController.currentToolId == id do
                placeBlock()
            end
        end
    end)

    tool.data.mouseUpEvent = engine.input:mouseLeftReleased(function()
        mouseDown = 0
    end)
    
    while active and wait() do
        local mouseHit = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, tool.data.placeholderBlock)
        if #mouseHit > 0 then
            tool.data.placeholderBlock.position = mouseHit[1].hitPosition + vector3(0, 0.5, 0)
        end
    end
    
end

local toolDeactivated = function(toolId)
    
    selectionController.selectable = true
    local tool = toolsController.tools[toolId]
    
    tool.data.mouseDownEvent:disconnect()
    tool.data.mouseDownEvent = nil
    tool.data.mouseUpEvent:disconnect()
    tool.data.mouseUpEvent = nil
    
    tool.data.placeholderBlock:destroy()
    tool.data.placeholderBlock = nil
    
    active = false

end

return toolController.add({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    activated = toolActivated,
    deactivated = toolDeactivated

})
