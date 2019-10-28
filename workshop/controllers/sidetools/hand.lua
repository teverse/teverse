-- Copyright 2019 Teverse.com

-- Tool Constants:
local toolName = "Hand"
local toolDesc = ""
local toolIcon = "fa:s-hand-pointer"

local clickEvent = nil

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