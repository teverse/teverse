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
local uiController = require("tevgit:create/controllers/ui.lua")
local propertyController  = require("tevgit:create/controllers/propertyEditor.lua")
local toolSettings  = require("tevgit:create/controllers/toolSettings.lua")
local helpers = require("tevgit:create/helpers.lua")

local toolIsActive

-- storing tool specific content in tool.data isn't really needed anymore due to modules...
local placeholderBlock = engine.construct(
        "block", 
        nil, 
        {
            name = "createModeAddToolPlaceholderObject",
            size = vector3(1, 1, 1),
            static = true,
            opacity = 0.5,
            physics = false,
            workshopLocked=true,
            static=true,
            castsShadows = false,
            position = vector3(0, -100, 0)     
        }
    )

local insertProps = {
    opacity = 1,
    castsShadows = true,
    name = "newBlock",
    static=true
}

local configWindow = uiController.createWindow(uiController.workshop.interface, guiCoord(0, 66, 0, 203), guiCoord(0, 140, 0, 48), "Inserter")
local gridLabel = uiController.create("guiTextBox", configWindow.content, {
    size = guiCoord(1,-10,1,-10),
    position = guiCoord(0,5,0,5),
    align = enums.align.middle,
    text = "Edit Insertable"
}, "main")

local editing = false
local db = false

gridLabel:mouseLeftReleased(function ()
    if editing then editing = false return end
    if db then return end
    db = true

    editing = true
    gridLabel.text = "Back"

    -- hide these from the property editor...
    propertyController.excludePropertyList = {
        ["position"]=true,
        ["workshopLocked"]=true,
        ["name"]=true
    }

    local wasPropertyEditing = propertyController.instanceEditing

    propertyController.generateProperties(placeholderBlock)
    propertyController.window.visible = true

    local startSize = propertyController.window.size
    local startPos  = propertyController.window.position

    engine.tween:begin(propertyController.window, 0.25, {position = guiCoord(2/3, 0, 0, 100), size = guiCoord(1/3, -10, 1, -110)}, "inOutQuad")

    local camPos = workspace.camera.position
    local camRot = workspace.camera.rotation

    placeholderBlock.position = vector3(0,-1000,0)
    for p,v in pairs(insertProps) do
        placeholderBlock[p] = v
    end

    workspace.camera.position = vector3(-3,-1000,-20)
    workspace.camera:lookAt(vector3(-3,-999,0))

    repeat 
        wait()
    until propertyController.instanceEditing ~= placeholderBlock or not editing or not toolIsActive 

    for p,v in pairs(insertProps) do
        insertProps[p] = placeholderBlock[p]
    end

    placeholderBlock.opacity = 0.5
    placeholderBlock.name = "createModeAddToolPlaceholderObject"
    placeholderBlock.castsShadows = false
    placeholderBlock.physics = false
    placeholderBlock.static = true
    placeholderBlock.workshopLocked = true

    workspace.camera.position = camPos
    workspace.camera.rotation = camRot

    engine.tween:begin(propertyController.window, 0.25, {position = startPos, size = startSize}, "inOutQuad")
    wait(0.3)

    propertyController.excludePropertyList = {}
    if wasPropertyEditing then
        propertyController.generateProperties(wasPropertyEditing)
    end

    editing = false
    db=false
    gridLabel.text = "Edit Insertable"

end)

configWindow.visible = false

local function onToolActivated(toolId)
    configWindow.visible = true
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


    --[[tool.data.placeholderBlock = engine.construct(
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
    )]]
    
    local lastInsertPosition = vector3(0.1,12,04)
    local function placeBlock()
        if lastInsertPosition ~= placeholderBlock.position then
            lastInsertPosition = placeholderBlock.position
            local newBlock = placeholderBlock:clone()
            newBlock.workshopLocked = false
            newBlock.physics = true
            newBlock.parent = engine.workspace
            
            for p,v in pairs(insertProps) do
                newBlock[p] = v
            end

            propertyController.generateProperties(newBlock)
            selectionController.setSelection({newBlock})
        end
    end
    
    tool.data.mouseDownEvent = engine.input:mouseLeftPressed(function(input)
		if input.systemHandled then return end 
		
        placeBlock()
        local curTime = os.clock()
        mouseDown = curTime
        wait(1) 
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

    tool.data.keyPressedEvent = engine.input:keyPressed(function(input)
        if input.systemHandled then return end 
        
        if input.key == enums.key.r then
            placeholderBlock.rotation = placeholderBlock.rotation * quaternion:setEuler(0,math.rad(45),0)
        end
    end)
    

    while (toolIsActive and wait() and placeholderBlock) do
        if not editing then
            local mouseHit = engine.physics:rayTestScreenAllHits(engine.input.mousePosition, placeholderBlock)
            if #mouseHit > 0 then
                placeholderBlock.position = helpers.roundVectorWithToolSettings(mouseHit[1].hitPosition + vector3(0, 0.5, 0)) 
            end
        end
    end
    placeholderBlock.position = vector3(0,-10000,0) --lol
end

local function onToolDeactivated(toolId)
    
    configWindow.visible = false
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
    tool.data.keyPressedEvent:disconnect()
    tool.data.keyPressedEvent = nil
    
    --tool.data.placeholderBlock:destroy()
    --tool.data.placeholderBlock = nil
    placeholderBlock.position = vector3(0,-10000,0) --lol
    placeholderBlock.static = true
    placeholderBlock.physics = false
end

return toolsController:register({
    
    name = TOOL_NAME,
    icon = TOOL_ICON,
    description = TOOL_DESCRIPTION,

    hotKey = enums.key.number1,

    activated = onToolActivated,
    deactivated = onToolDeactivated

})


