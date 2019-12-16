-- the front-end for /workshop/controllers/core/history.lua

local shared = require("tevgit:workshop/controllers/shared.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local history = shared.controllers.history

local window = ui.window(shared.workshop.interface,
   "History",
   guiCoord(0, 420, 0, 250), --size
   guiCoord(0.5, -210, 0.5, -25), --pos
   false, --dockable
   true -- hidable
)

local function draw()
    window.content:destroyAllChildren()
    
    local actions = history.getActions()
    local latestAction = history.getPointer()

    local yPos = 0

    -- render 'future' actions that are still on the stack
    -- these only exist if the user has undone something but hasn't started a new action
    if actions[latestAction+1] ~= nil then
        local i = latestAction + 1
        while actions[i] ~= nil do
            local action = actions[i]
            local formattedDate = os.date("%H:%M:%S", action[1])
            local actionName = action[2]:len() > 5 and action[2]:sub(0, 4) .. "..." or action[2]

            ui.create("guiTextBox", window.content, {
                size = guiCoord(1, 0, 0, 18),
                position = guiCoord(0, 0, 0, yPos),
                fontFile = "tevurl:font/OpenSans-Italic.ttf",
                text = string.format("[ UNDONE ] %s (change: %i, add: %i, rem: %i)", actionName, history.count(action[3]), history.count(action[4]), history.count(action[5]))
            }, "backgroundText")

            yPos = yPos + 20
            i = i + 1
        end
    end

    for i = latestAction, 0, -1 do
        local action = actions[i]
        if action then
            local formattedDate = os.date("%H:%M:%S", action[1])
            local actionName = action[2]:len() > 5 and action[2]:sub(0, 4) .. "..." or action[2]

            ui.create("guiTextBox", window.content, {
                size = guiCoord(1, 0, 0, 18),
                position = guiCoord(0, 0, 0, yPos),
                text = string.format("[ %s ] %s (change: %i, add: %i, rem: %i)", formattedDate, actionName, history.count(action[3]), #action[4], #action[5])
            }, "backgroundText")

            yPos = yPos + 20
        end
    end
end

draw()
history.setCallback(draw)

return window