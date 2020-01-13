-- Returns a frame with the different theme colours
-- Useful for overviewing a theme?

local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")
local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")
local colourPicker = require("tevgit:workshop/controllers/ui/components/colourPicker.lua")

local container = ui.create("guiFrame", shared.workshop.interface, {
   size = guiCoord(1, -10, 1, 0),
   position = guiCoord(0, 10, 0, 10)
}, "background")

local theme = themer.getTheme()
local y = 0
for _,prop in pairs(themer.types) do
   local themeProperty = engine.construct("guiFrame", container, {
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

   local count = 0
   for _,v in pairs(theme[prop]) do if type(v) == "colour" then count = count + 1 end end

   local size = 1/count
   local i = 0

   for k,v in pairs(theme[prop]) do
      if type(v) == "colour" then
         local ch,cs,cv = v:getHSV()
         local btn = ui.create("guiTextBox", themeProperty, {
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
            print(theme, prop, k)
            colourPicker.prompt(theme[prop][k], function(c)
               theme[prop][k] = c
               themer.setTheme(theme)
            end)
         end)
         i = i + 1 
      end
   end

   y = y + 44
end


return container