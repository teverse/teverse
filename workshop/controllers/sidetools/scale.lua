-- Copyright 2019 Teverse.com

-- Tool Constants:
local toolName = "Scale"
local toolDesc = ""
local toolIcon = "fa:s-expand"

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
