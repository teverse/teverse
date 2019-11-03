local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local tabs = {
   ["Main"] = {
      {"Open", "fa:s-folder-open", function()
         shared.workshop:openFileDialogue()
      end},
      {"Save", "fa:s-save", function()
         shared.workshop:saveGame()
      end},
      {"Save As", "fa:r-save", function()
         shared.workshop:saveGameAsDialogue()
      end},
      {"Seperator"},
      {"Properties", "fa:s-clipboard-list", function ()
        shared.windows.propertyEditor.visible = not shared.windows.propertyEditor.visible
      end},
      {"Settings", "fa:s-cog", function ()
        shared.windows.settings.visible = not shared.windows.settings.visible
      end},
      {"History", "fa:s-history", function ()
        shared.windows.history.visible = not shared.windows.history.visible
      end}
   }
}

if shared.developerMode then
  tabs["Development"] = {
    {"Reload", "fa:s-sync-alt", function()
        shared.workshop:reloadCreate()
    end},
    {"Run Lua", "fa:s-chevron-right", function()
        shared.windows.runLua.visible = not shared.windows.runLua.visible
    end}
  }
end

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

   xpos = 12
   for i,v in pairs(options) do
     if v[1] == "Seperator" then
       local seperator = ui.create("guiFrame", newSubMenu, {
         size = guiCoord(0, 2, 0.6, 0),
         position = guiCoord(0, xpos, 0.2, 0)
       }, "primary")
       xpos = xpos + 12
     else
        local newOption = ui.create("guiFrame", newSubMenu, {
           size = guiCoord(0, 56, 0, 46),
           position = guiCoord(0, xpos, 0, 2),
           hoverCursor = "fa:s-hand-pointer"
        }, "primaryVariant")

        if type(v[3]) == "function" then
           newOption:mouseLeftPressed(v[3])
        end

        ui.create("guiImage", newOption, {
           size = guiCoord(0, 20, 0, 20),
           position = guiCoord(0, 18, 0, 6),
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

        xpos = xpos + 62
    end
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
