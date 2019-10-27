local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local tools = require("tevgit:workshop/controllers/sidetools/main.lua")

local toolBar = ui.create("guiFrame", shared.workshop.interface, {
   name = "toolBar",
   size = guiCoord(0, 32, 0, 100),
   position = guiCoord(0, 14, 0, 90)
}, "primary")

local activeTool = nil

local currentY = 2
for toolName, options in pairs(tools) do

	-- options is the table returned by the tool's module.
	-- e.g. workshop/controllers/sidetools/hand.lua

   local newTabBtn = ui.create("guiTextBox", toolBar, {
      text     = toolName,
      position = guiCoord(0, 2, 0, currentY),
      size     = guiCoord(0, 24, 0, 24),
      hoverCursor = "fa:s-hand-pointer"
   }, "primary")

   tools[toolName].gui = newTabBtn
   
   if options.icon then
      newTabBtn.text = ""
      ui.create("guiImage", newTabBtn, {
         name = "icon",
         size = guiCoord(0.9, 0, 0.9, 0),
         position = guiCoord(0.05, 0, 0.05, 0),
         texture = options.icon,
         handleEvents = false
      }, "secondaryImage")
   end

   newTabBtn:mouseLeftPressed(function ()
      if activeTool ~= toolName then
         if activeTool then
            tools[activeTool].deactivate()
            themer.registerGui(tools[activeTool].gui.icon, "secondaryImage")
         end
         tools[toolName].activate()
         themer.registerGui(tools[toolName].gui.icon, "primaryImage")
         activeTool = toolName
      else
         tools[activeTool].deactivate()
         themer.registerGui(tools[activeTool].gui.icon, "secondaryImage")
         activeTool = nil
      end
   end)

   currentY = currentY + 26
end