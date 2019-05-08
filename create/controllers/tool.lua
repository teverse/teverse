


--[[
    Copyright 2019 Teverse
    @File tool.lua
    @Author(s) Jay, Ly
    @Updated 5/8/19
--]]

TOOL_BUTTON_SIZE = guiCoord(0, 30, 0, 30)
TOOL_BUTTON_DEFAULT_POSITION = guiCoord(0, 5, 0, 5)
TOOL_BUTTON_OFFSET = guiCoord(0, 0, 0, 40)

local toolsController = {

    currentToolId = 0,
    tools = {},

    ui = nil,
    workshop = nil,
    container = nil

}

local themeController = require("tevgit:create/controllers/theme.lua")


local function onToolButtonMouseLeftReleased(toolId) 
   
    --[[
        @Description 
            Manages toggling tools when a button is clicked

        @Params
            Integer, toolId
                The unique # of the tool 
    ]]

    if (toolsController.currentToolId > 0) then

        -- @Note Deactive current tool in use 
        local currentTool = toolsController.tools[toolsController.currentToolId]
        print("Debug: Deactivating tool " .. currentTool.name)
        currentTool.button.imageColour = themeController.currentTheme.tools.deselected
        currentTool.deactivated(currentTool.id)   

    end

    if toolsController.currentToolId == toolId then
        
        -- @Note Deselects tool {toolId}
        print("Debug: Deselecting tools")
        toolsController.currentToolId = 0

    else

        -- @Note Selects tool {toolId}
        toolsController.currentToolId = toolId
        local currentTool = toolsController.tools[toolsController.currentToolId]
        print("Debug: Activating tool " .. currentTool.name)
        currentTool.button.imageColour = themeController.currentTheme.tools.selected
        currentTool.activated(currentTool.id)

    end

end

function toolsController:register(tool) 

    --[[
        @Description 
            Registers a tool into the controller

        @Params
            Dictionary, tool
                The given information about a {tool} including its functions
                @Model {
                    
                    name = String,
                    icon = String,
                    description = String,
                    data = [Dictionary],

                    activated = Function,
                    deactivated = Functon,

                }
                
        @Returns
            Integer, toolId
                The resultant unique # of the tools that was registered
    ]]

    local toolId = #self.tools + 1
    
    local toolButton = self.ui.create(
        "guiImage",
        self.container,
        {
            size = TOOL_BUTTON_SIZE,
            position = TOOL_DEFAULT_POSITION + (TOOL_BUTTON_OFFSET * #self.tools),
            guiStyle = enums.guiStyle.noBackground,
            imageColour = themeController.currentTheme.tools.deselected,
            texture = tool.icon
        },
        "main"
    )

    toolButton:mouseLeftReleased(function()
        onToolButtonMouseLeftReleased(toolId)
    end)

    self.tools[toolId] = {
        
        id = toolId, 
        name = tool.name, 
       
        button = button, 
        data = tool.data and tool.data or {},

        activated = tool.activated, 
        deactivated = tool.deactivated

    }
    
    return toolId

end

return toolsController

