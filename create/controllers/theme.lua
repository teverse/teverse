-- Copyright 2019 teverse.com

local themeController = {}

themeController.currentTheme = {}
themeController.guis = {} --make this a weak metatable (keys)

themeController.setTheme = function(theme)
    
end)

themeController.applyTheme = function(gui)
local style = themeController.guis[gui]
end

themeController.add = function(gui, style)
    if themeController.guis[gui] then return end
    
    themeController.guis[gui] = style
themeController.applyTheme(gui)
end

return themeController
