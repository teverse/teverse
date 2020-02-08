-- Returns a frame with the different theme colours
-- Useful for overviewing a theme?

ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
shared = require("tevgit:workshop/controllers/shared.lua")
themer = require("tevgit:workshop/controllers/ui/core/themer.lua")
colourPicker = require("tevgit:workshop/controllers/ui/components/colourPicker.lua")

presets = {
   {"default", "Classic (default)"},
   {"black", "Tev Dark"},
   {"white", "Tev Light"},
   {"ow", "ow my eyes"},
   {"custom", "Custom"}
}

container = ui.create("guiFrame", shared.workshop.interface, {
   size = guiCoord(1, -10, 0, 560),
   position = guiCoord(0, 10, 0, 10)
}, "background")

presetMenu = ui.create("guiFrame", container, {
   position = guiCoord(0, 0, 0, 0),
   size = guiCoord(0.5, 0, 0, 140),
   borderRadius = 3
}, "primary")

importWindow = ui.window(shared.workshop.interface,
   "Import Theme",
   guiCoord(0, 420, 0, 230), --size
   guiCoord(0.5, -210, 0.5, -25), --pos
   false, --dockable
   true -- hidable
)
importWindow.visible = false
importWindow.xIndex = 1000

frame = ui.create("guiFrame", importWindow.content, {
	size = guiCoord(1, -20, 1, -60),
	position = guiCoord(0, 10, 0, 10),
   cropChildren = true,
   backgroundAlpha = 0
})
importInput = ui.create("guiTextBox", frame, {
	size = guiCoord(1, 0, 1, 0),
	position = guiCoord(0, 0, 0, 0),
	readOnly = false,
	wrap = true,
   fontSize = 16,
   zIndex = 100
}, "secondary")

function attemptCustom()
   import = importInput.text
   import = string.gsub(import,"\\","")
   themer.setTheme(engine.json:decode(import))
end

importConfirmButton = ui.button(importWindow.content, "Import", guiCoord(0.5, 0, 0, 30), guiCoord(0.25, 0, 1, -40), "primary")

importButton = ui.create("guiButton", container, {
   size = guiCoord(0.5, -20, 0, 30),
   position = guiCoord(0.5, 10, 0, 40),
   borderRadius = 3,
   text = "Import Theme",
   align = enums.align.middle
},"primaryVariant"):mouseLeftReleased(function()
   importWindow.visible = true
end)

exportWindow = ui.window(shared.workshop.interface,
   "Export Theme",
   guiCoord(0, 420, 0, 230), --size
   guiCoord(0.5, -210, 0.5, -25), --pos
   false, --dockable
   true -- hidable
)
exportWindow.visible = false

eframe = ui.create("guiFrame", exportWindow.content, {
	size = guiCoord(1, -20, 1, -20),
	position = guiCoord(0, 10, 0, 10),
   cropChildren = true,
   backgroundAlpha = 0
})

exportInput = ui.create("guiTextBox", eframe, {
	size = guiCoord(1, 0, 1, 0),
	position = guiCoord(0, 0, 0, 0),
	readOnly = false,
	wrap = true,
   fontSize = 16,
   zIndex = 100
}, "secondary")

THISISTHERESETBUTTON = ui.create("guiButton", container, {
   size = guiCoord(0.5, -20, 0, 30),
   position = guiCoord(0.5, 10, 0, 80),
   borderRadius = 3,
   text = "Export Theme",
   align = enums.align.middle,
   visible = false
},"primaryVariant")
THISISTHERESETBUTTON:mouseLeftReleased(function()
   exportInput.text = shared.workshop:getSettings("customTheme")
   exportWindow.visible = true
end)

customUI = ui.create("guiFrame", container, {
   size = guiCoord(1, -10, 2, 0),
   position = guiCoord(0, 0, 0, 150),
   visible = false
}, "background")

theme = themer.getTheme()
function themeReload()
   theme = null
   theme = themer.getTheme()
end

function generateEditor()
   customUI:destroyAllChildren()
   local y = 0
   for _,prop in pairs(themer.types) do
      themeProperty = engine.construct("guiFrame", customUI, {
         size = guiCoord(1, 0, 0, 40),
         position = guiCoord(0, 0, 0, y),
         backgroundAlpha = 0
      })
      
      ui.create("guiTextBox", themeProperty, {
         size = guiCoord(1, -10, 0, 16),
         position = guiCoord(0, 6, 0, 2),
         text = prop,
         fontSize = 16,
         align = enums.align.middleLeft,
         fontFile = "local:OpenSans-SemiBold.ttf"
      }, "backgroundText")

      count = 0
      for _,v in pairs(theme[prop]) do if type(v) == "colour" then count = count + 1 end end

      size = 1/count
      i = 0

      for k,v in pairs(theme[prop]) do
         if type(v) == "colour" then
            local ch,cs,cv = v:getHSV()
            btn = ui.create("guiTextBox", themeProperty, {
               size = guiCoord(size, -10, 0, 20),
               position = guiCoord(size*i, 5, 0, 20),
               text = k,
               fontSize = 16,
               align = enums.align.middle,
               backgroundColour = v,
               textColour = cv > 0.5 and colour:black() or colour:white(),
               borderRadius = 4,
               borderColour = colour:black(),
               borderAlpha = 0.3
            }, prop)

            btn:mouseLeftReleased(function()
               colourPicker.prompt(theme[prop][k], function(c)
                  theme[prop][k] = c
                  themer.setTheme(theme)
                  exportInput.text = engine.json:decode(shared.workshop:getSettings("customTheme"))
                  themeReload()
               end)
            end)
            i = i + 1 
         end
      end

      y = y + 44
   end
end

function canvasSet(size)
   container.parent.canvasSize = size
   container.size = size
end

function makePresetMenu()
   preset = shared.workshop:getSettings("themeType")
   THISISTHERESETBUTTON.visible = false
   customUI.visible = false
   pcall(canvasSet, guiCoord(1, 0, 1, 0))
   if shared.workshop:getSettings("themeType") == "custom" then
      THISISTHERESETBUTTON.visible = true
      customUI.visible = true
      generateEditor()
      pcall(canvasSet, guiCoord(1, 0, 0, 560))
   end

   presetMenu:destroyAllChildren()

   local y = 0
   for i = 1, #presets do
      if preset == presets[i][1] then background = 1 else background = 0 end
      preset = ui.create("guiButton", presetMenu, {
         size = guiCoord(1, 0, 0, 20),
         position = guiCoord(0, 0, 0, y),
         backgroundAlpha = background,
         text = " " .. presets[i][2],
         borderRadius = 3
      },"secondary"):mouseLeftReleased(function()
         if presets[i][1] == "custom" then
            shared.workshop:setSettings("themeType", presets[i][1])
            shared.workshop:setSettings("customTheme", engine.json:encodeWithTypes(theme))
            themer.setTheme(theme)
            themeReload()
         else
            shared.workshop:setSettings("themeType", presets[i][1])
            themer.setThemePreset(require("tevgit:workshop/controllers/ui/themes/" .. presets[i][1] .. ".lua"))
            themeReload()
         end
         makePresetMenu()
      end)
      y = y + 20
   end
end

importConfirmButton:mouseLeftReleased(function()
   success, message = pcall(attemptCustom)
   if success then
      makePresetMenu()
      importWindow.visible = false  
      importInput.text = ""    
   else
      ui.prompt("The given theme is invalid, the theme has not been changed.")
   end
end)

resetButton = ui.create("guiButton", container, {
   size = guiCoord(0.5, -20, 0, 30),
   position = guiCoord(0.5, 10, 0, 0),
   borderRadius = 3,
   text = "Reset Theme",
   align = enums.align.middle
},"secondary"):mouseLeftReleased(function()
   shared.workshop:setSettings("themeType", "default")
   themer.setThemePreset(require("tevgit:workshop/controllers/ui/themes/default.lua"))
   themeReload()
   makePresetMenu()
end)

makePresetMenu()

return container