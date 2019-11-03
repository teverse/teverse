-- Copyright 2019 Teverse.com

-- Tool Constants:
local toolName = "Rotate"
local toolDesc = ""
local toolIcon = "fa:s-redo"

return {
    name = toolName,
    icon = toolIcon,
    desc = toolDesc,

    activate = function()
    	print("tool activated")
    end,

    deactivate = function ()
    	print("tool deactivated")
    end
}
