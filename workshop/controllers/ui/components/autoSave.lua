-- Auto Save 
local shared = require("tevgit:workshop/controllers/shared.lua")
local autoSave = {}

autoSave.Enabled = false
autoSave.timeLimit = 5 -- Default (move to settings value soon)

autoSave.Sync = function()
    spawnThread(function()
        while true do
            if autoSave.Enabled then
                shared.workshop:saveGame()
            end
            wait(autoSave.timeLimit)
        end
    end)
end

return autoSave