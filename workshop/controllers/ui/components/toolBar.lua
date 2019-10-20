local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local tools = require("tevgit:workshop/controllers/sidetools/main.lua")

local toolBar = ui.create("guiFrame", shared.workshop.interface, {
   name = "toolBar",
   size = guiCoord(0, 32, 0, 100),
   position = guiCoord(0, 14, 0, 90)
}, "primary")


local currentY = 2
for toolName, options in pairs(tools) do

	-- options is the table returned by the tool's module.
	-- e.g. workshop/controllers/sidetools/hand.lua

   local newTabBtn = ui.create("guiTextBox", topBar, {
      text     = toolName,
      position = guiCoord(0, 2, 0, currentY),
      size     = guiCoord(0, 24, 0, 24),
      hoverCursor = "fa:s-hand-pointer"
   }, "primary")
   
   currentY = currentY + 26
end