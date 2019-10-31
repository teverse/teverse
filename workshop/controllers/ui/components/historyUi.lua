-- the front-end for /workshop/controllers/core/history.lua

local shared = require("tevgit:workshop/controllers/shared.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local history = shared.controllers.history

local window = ui.window(shared.workshop.interface,
   "History",
   guiCoord(0, 420, 0, 300), --size
   guiCoord(0.5, -210, 0.5, -25), --pos
   false, --dockable
   true -- hidable
)

local function draw()
    window.content:destroyAllChildren()
    
    local actions = history.getActions()
    local latestAction = history.getPointer()

    local yPos = 0
    for i = latestAction, 0, -1 do
        local action = actions[i]
        if action then
            ui.create("guiTextBox", window.content, {
                size = guiCoord(1, 0, 0, 18),
                position = guiCoord(0, 0, 0, yPos),
                text = action[1] .. "(" .. history.count(action[2]) .. " objects changed)"
            }, "backgroundText")

            yPos = yPos + 18
        end
    end
end

draw()
history.setCallback(draw)

return window