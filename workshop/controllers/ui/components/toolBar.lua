local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local tools = require("tevgit:workshop/controllers/sidetools/main.lua")

local toolBar = ui.create("guiFrame", shared.workshop.interface, {
   name = "_toolBar",
   size = guiCoord(0, 32, 0, 100),
   position = guiCoord(0, 8, 0, 80),
   backgroundAlpha = 0.8,
   borderRadius = 4
}, "primary")

local activeTool = nil

local currentY = 5
for toolName, options in pairs(tools) do

	-- options is the table returned by the tool's module.
	-- e.g. workshop/controllers/sidetools/hand.lua

   local newTabBtn = ui.create("guiTextBox", toolBar, {
      text     = toolName,
      position = guiCoord(0, 5, 0, currentY),
      size     = guiCoord(0, 22, 0, 22),
      hoverCursor = "fa:s-hand-pointer"
   }, "primaryText")

   tools[toolName].gui = newTabBtn
   
   if options.icon then
      newTabBtn.text = ""
      ui.create("guiImage", newTabBtn, {
         name = "icon",
         size = guiCoord(1, 0, 1, 0),
         position = guiCoord(0, 0, 0., 0),
         texture = options.icon,
         handleEvents = false,
         imageAlpha = 0.75
      }, "secondaryImage")
   end

   newTabBtn:mouseLeftPressed(function ()
      if activeTool ~= toolName then
         if activeTool then
            tools[activeTool].deactivate()
            tools[activeTool].gui.icon.imageAlpha = 0.75
         end
         tools[toolName].activate()
         tools[toolName].gui.icon.imageAlpha = 1
         activeTool = toolName
      else
         tools[activeTool].deactivate()
         tools[activeTool].gui.icon.imageAlpha = 0.75
         activeTool = nil
      end
   end)

   currentY = currentY + 32
end

toolBar.size = guiCoord(0, 32, 0, currentY - 5)