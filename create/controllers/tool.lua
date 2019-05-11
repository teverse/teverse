--[[
    Copyright 2019 Teverse
    @File tool.lua
    @Author(s) Jay, Ly
    @Updated 5/8/19
--]]

TOOL_BUTTON_SIZE = guiCoord(0, 30, 0, 30)
TOOL_BUTTON_DEFAULT_POSITION = guiCoord(0, 5, 0, 5)
TOOL_BUTTON_OFFSET = 40

local toolsController = {

    currentToolId = 0,
    tools = {},

    ui = nil,
    workshop = nil,
    container = nil

}

-- Not sure if the following should be in this controller... Oh well.
toolsController.menus = {}

-- You must create the gui before calling this function
-- This function simply registers the menu to this controller.
function toolsController.registerMenu(name, gui)
    if toolsController.menus[name] then
        return error("Menu already exists", 2)
    end
    
    toolsController.menus[name] = {gui = gui, buttons = {}, currentX = 0, currentY = 0}
    
    return true
end

-- Each button would be able to have their own size, and it is this controller's
-- responsibility to position them properly.
function toolsController.registerButton(name, gui)
    if not toolsController.menus[name] then
        return error("Menu doesn't exist", 2)
    end
    
    table.insert(toolsController.menus[name], {gui=gui})
    
    gui.parent = toolsController.menus[name].gui
    gui.position = guiCoord(0, menu.currentX, 0, menu.currentY)
    
    local menu = toolsController.menus[name]
    local guiSize = gui.absoluteSize
    if menu.currentY + guiSize.y > menu.gui.absoluteSize.y then
        menu.currentY = 0
        menu.currentX = menu.currentX + guiSize.x
    else
        menu.currentY = menu.currentY + guiSize.y
    end
end

-- Creates a button with an image and a label and registers it.
function toolsController.createButton(menuName, image, label)
    local menu = toolsController.menus[menuName]
    local gui = toolsController.ui.createFrame(menu.gui, {size=guiCoord(0,50,0,60)}, "main")
    local img = toolsController.ui.create("guiImage", gui, {size=guiCoord(0, 40, 0, 40), position=guiCoord(0,5,0,5), texture=image}, "main")
    local txt = toolsController.ui.create("guiTextBox", gui, {size=guiCoord(0, 50, 0, 15), position=guiCoord(0,5,0,5), text=label}, "main")
    toolsController.registerButton(menuName, gui)
end

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
            position = TOOL_BUTTON_DEFAULT_POSITION + guiCoord(0, 0, 0, TOOL_BUTTON_OFFSET * #self.tools),
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
       
        button = toolButton, 
        data = tool.data and tool.data or {},

        activated = tool.activated, 
        deactivated = tool.deactivated

    }
    
    return toolId

end

return toolsController

