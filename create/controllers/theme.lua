-- Copyright 2019 teverse.com

local themeController = {}

themeController.guis = {}

themeController.add = function(gui, style)
    if themeController.guis[gui] then return end
    
    themeController.guis[gui] = style
end

return themeController
