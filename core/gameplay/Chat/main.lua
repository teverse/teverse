-- Copyright 2020- Teverse
-- This script constructs (or builds) the default in-game chat system on the client

return {
    init = function()
        require("tevgit:core/gameplay/Chat/ui.lua").ui()
        require("tevgit:core/gameplay/Chat/server.lua")
    end
}