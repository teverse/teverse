--[[
    Copyright 2019 Teverse
    @File tool.lua
    @Author(s) Jay, Ly
    @Updated 5/8/19
--]]

TOOL_BUTTON_SIZE = guiCoord(0, 30, 0, 30)
TOOL_BUTTON_DEFAULT_POSITION = guiCoord(0, 8, 0, 8)
TOOL_BUTTON_OFFSET = 45

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
    
    toolsController.menus[name] = {gui = gui, buttons = {}, currentX = 5, currentY = 0}
    
    return true
end

-- Each button would be able to have their own size, and it is this controller's
-- responsibility to position them properly.
function toolsController.registerButton(name, gui)
    if not toolsController.menus[name] then
        return error("Menu doesn't exist", 2)
    end
    
    table.insert(toolsController.menus[name], {gui=gui})
    
    local menu = toolsController.menus[name]

    gui.parent = menu.gui
    gui.position = guiCoord(0, menu.currentX, 0, menu.currentY)
    
    local guiSize = gui.absoluteSize
    if menu.currentY + guiSize.y >= menu.gui.absoluteSize.y then
        menu.currentY = 0
        menu.currentX = menu.currentX + guiSize.x + 5
    else
        menu.currentY = menu.currentY + guiSize.y
        print( menu.currentY )
    end
end

-- Creates a button with an image and a label and registers it.
-- height should be a decimal.
function toolsController.createButton(menuName, image, label, height)
    if not height then height = 1 end
    local menu = toolsController.menus[menuName]
    local gui = toolsController.ui.createFrame(menu.gui, {size=guiCoord(0,50,height,0)}, "secondary")
    if image then
        local imgSize = math.min(50, menu.gui.absoluteSize.y) - 5
        local img = toolsController.ui.create("guiImage", gui, {size=guiCoord(0, (2/3) * imgSize, 0, (2/3) * imgSize), position=guiCoord(0.5, -((1/3) * imgSize),0,5), texture=image, handleEvents=false}, "secondary")
    end
    local txt = toolsController.ui.create("guiTextBox", gui, {size=guiCoord(1, 0, image and 1/3 or 1, -5), position=guiCoord(0,0,image and 2/3 or 0,0), text=label, fontSize=15, align=enums.align.middle, handleEvents=false}, "secondary")
    toolsController.registerButton(menuName, gui)
    return gui
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

    local containerSize = self.container.size
    containerSize.scaleY = 0
    containerSize.offsetY = TOOL_BUTTON_OFFSET * #self.tools
    self.container.size = containerSize
    return toolId

end

return toolsController

