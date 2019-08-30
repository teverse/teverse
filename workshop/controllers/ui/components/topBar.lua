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
   ["Windows"] = {
      {"Settings", "fa:s-cog", function ()
         shared.windows.settings.visible = not shared.windows.settings.visible
      end}
   }
}

local topBar = ui.create("guiFrame", shared.workshop.interface, {
   name = "topBar",
   size = guiCoord(1, 0, 0, 22)
}, "primary")

local topBarSubMenu = ui.create("guiFrame", shared.workshop.interface, {
   name = "topBarSubMenu",
   size = guiCoord(1, 0, 0, 50),
   position = guiCoord(0, 0, 0, 22)
}, "primaryVariant")

local currentX = 20
local guiTabs = {}

for tabName, options in pairs(tabs) do
   local newTabBtn = ui.create("guiTextBox", topBar, {
      text     = tabName,
      position = guiCoord(0, currentX, 0, 2),
      fontSize = 20,
      align    = enums.align.middle,
      hoverCursor = "fa:s-hand-pointer"
   }, "primaryVariant")
   
   local newSubMenu = engine.construct("guiFrame", topBarSubMenu, {
      size = guiCoord(1, 0, 1, 0),
      backgroundAlpha = 0
   })

   for i,v in pairs(options) do
      local newOption = ui.create("guiFrame", newSubMenu, {
         size = guiCoord(0, 46, 0, 46),
         position = guiCoord(0, 12 + ((i-1) * 52), 0, 2),
         hoverCursor = "fa:s-hand-pointer"
      }, "primaryVariant")

      if type(v[3]) == "function" then
         newOption:mouseLeftPressed(v[3])
      end

      ui.create("guiImage", newOption, {
         size = guiCoord(0, 20, 0, 20),
         position = guiCoord(0, 13, 0, 6),
         texture = v[2],
         handleEvents = false
      }, "primaryImage")

      ui.create("guiTextBox", newOption, {
         size = guiCoord(1, 0, 0, 16),
         position = guiCoord(0, 0, 0, 30),
         text = v[1],
         handleEvents = false,
         align = enums.align.middle,
         fontSize = 15
      }, "primaryText")
   end

   newTabBtn:mouseLeftPressed(function ()
      for btn, submenu in pairs(guiTabs) do
         btn.backgroundAlpha = 0
         submenu.visible = false
      end
      newSubMenu.visible = true
      newTabBtn.backgroundAlpha = 1
   end)

   if currentX > 20 then
      newSubMenu.visible = false
      newTabBtn.backgroundAlpha = 0
   end

   local txtDim = newTabBtn.textDimensions
   newTabBtn.size = guiCoord(0, txtDim.x + 20, 0, 20)
   currentX = currentX + txtDim.x + 30
   guiTabs[newTabBtn] = newSubMenu
end