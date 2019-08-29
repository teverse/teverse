local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local tabs = {
      ["File"] = {
            {"Open", "fa:s-question-circle", function()
                  -- callback
                  
            end},
            {"Save", "fa:s-question-circle"},
            {"Save As", "fa:s-question-circle"},
      },
      ["Example"] = {
      
      }
}

local topBar = ui.create("guiFrame", shared.workshop.interface, {
   name = "topBar",
   size = guiCoord(1, 0, 0, 22)
}, "primary")

local currentX = 10
for tabName, options in pairs(tabs) do
   local newTabBtn = ui.create("guiTextBox", topBar, {
      text     = tabName,
      position = guiCoord(0, currentX, 0, 2),
      fontSize = 20
   }, "primary")
   
   local txtDim = newTabBtn.textDimensions
   newTabBtn.size = guiCoord(0, txtDim.x + 20, 0, 20)
   currentX = currentX + txtDim.x + 30
end