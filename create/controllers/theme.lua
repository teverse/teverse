-- Copyright 2019 teverse.com

local themeController = {}

themeController.guis = {} --make this a weak metatable (keys)

themeController.setTheme = function(theme)
    
end)

themeController.add = function(gui, style)
    if themeController.guis[gui] then return end
    
    themeController.guis[gui] = style
end

return themeController
