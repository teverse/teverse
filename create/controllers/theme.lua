-- Copyright (c) 2019 teverse.com
-- theme.lua

local themeController = {}

print ("DEBUG: Loading theme.lua")

-- values from default are used in all styles unless overridden.
-- theme names are probably gonna have to get made meaningful...
themeController.currentTheme = {
    default = {
        fontFile = "OpenSans-Regular",
		backgroundColour  = colour:fromRGB(66, 66, 76),
		textColour = colour:fromRGB(255, 255, 255)
    },
    main = {
		backgroundColour  = colour:fromRGB(66, 66, 76),
		textColour = colour:fromRGB(255, 255, 255),
	},
	mainText = {
		guiStyle = enums.guiStyle.noBackground,
		textColour = colour:fromRGB(255, 255, 255),
	},
	mainTopBar = {
		backgroundColour  = colour:fromRGB(45, 45, 55),
		textColour = colour:fromRGB(255, 255, 255),
	},
	secondary = {
	    backgroundColour  = colour:fromRGB(55, 55, 66),
	    textColour  = colour:fromRGB(255, 255, 255)
	},
	primary = {
	    backgroundColour = colour:fromRGB(78, 83, 91),
	    textColour  = colour:fromRGB(255,255,255)
	},
	light = {
		backgroundColour  = colour:fromRGB(255,255,255),
		textColour = colour:fromRGB(66, 66, 76),
	},
	tools = {
		selected = colour:fromRGB(66, 134, 244),
		hovered = colour(0.9, 0.9, 0.9),
		deselected = colour(0.6, 0.6, 0.6)
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
    --if themeController.guis[gui] then return end
    
    themeController.guis[gui] = style
	themeController.applyTheme(gui)
end

return themeController
