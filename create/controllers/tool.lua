


TOOL_BUTTON_SIZE = guiCoord(0, 30, 0, 30)
TOOL_BUTTON_DEFAULT_POSITION = guiCoord(0, 5, 0, 5)
TOOL_BUTTON_OFFSET = guiCoord(0, 0, 0, 40)

local _M = {

    -- @property currentToolId
    -- @type Integer
    -- @desc The currently selected tool by Id
    -- 0 will mean that no tool is currently selected
    currentToolId = 0,

    -- @property tools
    -- @type Table
    -- @desc The list of registered tools
    tools = {},

    -- @note Ease of access, loaded when ui.lua completes
    ui = nil,
    workshop = nil,
    container = nil

}

local themeController = require("tevgit:create/controllers/theme.lua")

-- @section Primary functions
-- @function register
-- @param Tool<Dictionary>
-- @return toolId<Integer>
-- @desc Registers a tool into the controller 
function _M:register(tool) 

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

    table.insert(self.tools, {
        
        id = toolId, 
        name = tool.name, 
       
        button = button, 
        data = tool.data and tool.data or {},

        activated = tool.activated, 
        deactivated = tool.deactivated

    })
    
    return toolId

end

end

-- @section Event functions
-- @event onToolButtonMouseLeftReleased
-- @param toolId<Integer>
-- @desc Handles the toggling of tools
-- @review Should it be debounced?
local function onToolButtonMouseLeftReleased(toolId) 
   
    if (_M.currentToolId > 0) then

        -- @note Deactive current tool in use 
        local currentTool = _M.tools[_M.currentToolId]
        print("Debug: Deactivating tool " .. currentTool.name)
        currentTool.button.imageColour = themeController.currentTheme.tools.deselected
        currentTool.deactivated(currentTool.id)   

    end

    if _M.currentToolId == toolId then
        
        -- @note Deselects tool {toolId}
        print("Debug: Deselecting tools")
        _M.currentToolId = 0

    else

        -- @note Selects tool {toolId}
        _M.currentToolId = toolId
        local currentTool = _M.tools[_M.currentToolId]
        print("Debug: Activating tool " .. currentTool.name)
        currentTool.button.imageColour = themeController.currentTheme.tools.selected
        currentTool.activated(currentTool.id)

    end

end

return _M

