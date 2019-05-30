-- Copyright (c) 2019 teverse.com
-- theme.lua

local themeController = {}

print ("DEBUG: Loading theme.lua")

-- values from default are used in all styles unless overridden.
themeController.currentTheme = {
    default = {
        fontFile = "OpenSans-Regular",
		backgroundColour  = colour:fromRGB(33, 33, 33),
		textColour = colour:fromRGB(199, 199, 199)
    },
    main = {
		backgroundColour  = colour:fromRGB(33, 33, 33),
		textColour = colour:fromRGB(199, 199, 199),
	},
	secondary = {
	    backgroundColour  = colour:fromRGB(48, 48, 48),
	    textColour  = colour:fromRGB(199, 199, 199)
	},
	primary = {
	    backgroundColour = colour:fromRGB(48, 48, 48),
	    textColour  = colour:fromRGB(199, 199, 199)
	},
	light = {
		backgroundColour  = colour:fromRGB(242, 242, 242),
		textColour = colour:fromRGB(21, 21, 25),
	},
	tools = {
		selected = colour:fromRGB(0, 78, 203),
		hovered = colour:fromRGB(229, 230, 232),
		deselected = colour:fromRGB(199, 199, 199)
	}
}

themeController.guis = {} --make this a weak metatable (keys)

themeController.set = function(theme)
    themeController.currentTheme = theme
    for gui, style in pairs(themeController.guis) do
    	themeController.applyTheme(gui)
   	end
end

themeController.applyTheme = function(gui)
	local styleName = themeController.guis[gui]

	local style = themeController.currentTheme[styleName]
	if not style then
		style = {}
	end

	if themeController.currentTheme["default"] then
		for property, value in pairs(themeController.currentTheme["default"]) do
			if not style[property] and gui[property] and gui[property] ~= value then --Chosen style does not have this property
				gui[property] = value
			end
		end
	end

	for property, value in pairs(style) do
		if gui[property] and gui[property] ~= value then
			gui[property] = value
		end
	end
end

themeController.add = function(gui, style)
    if themeController.guis[gui] then return end

    themeController.guis[gui] = style
	themeController.applyTheme(gui)
end

return themeController
