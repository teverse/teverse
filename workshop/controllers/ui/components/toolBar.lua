local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local tools = require("tevgit:workshop/controllers/sidetools/main.lua")
local keybinder = require("tevgit:workshop/controllers/core/keybinder.lua")

-- main gui dock that is on left of the screen
-- it is moved by the dock controller IF windows are docked to the left side of the screen

local toolDock = engine.construct("guiFrame", shared.workshop.interface, {
   name = "_toolBar",
   cropChildren = false,
   backgroundAlpha = 0,
   position = guiCoord(0, 8, 0, 80),
})

local toolBar = ui.create("guiFrame", toolDock, {
   name = "_toolBar",
   size = guiCoord(0, 32, 0, 100),
   position = guiCoord(0, 0, 0, 0),
   backgroundAlpha = 0.8,
   borderRadius = 4
}, "primary")

local activeTool = nil

local function toggleTool(toolName)
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
end

local currentY = 5
local toolIndex = 0
for toolName, options in pairs(tools) do

   -- used to assign a number keybind to each tool
   toolIndex = toolIndex + 1

	-- options is the table returned by the tool's module.
	-- e.g. workshop/controllers/sidetools/hand.lua

   local newTabBtn = ui.create("guiTextBox", toolBar, {
      text     = toolName,
      position = guiCoord(0, 4, 0, currentY),
      size     = guiCoord(0, 24, 0, 24),
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
      }, "primaryImage")
   end

   local keybindText = ""
   if toolIndex < 10 then
      keybindText = " [" .. toolIndex .. "]"

      keybinder:bind({
         name = "Activate " .. options.name .. " tool",
         key = enums.key["number"..toolIndex],
         action = function() toggleTool(toolName) end
      })
   end
   -- shows a tool tip if the user hovers over the button
   ui.tooltip(newTabBtn, options.name .. keybindText)

   newTabBtn:mouseLeftPressed(function ()
      toggleTool(toolName)
   end)

   currentY = currentY + 32
end

toolBar.size = guiCoord(0, 32, 0, currentY - 5)