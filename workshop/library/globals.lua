-- Copyright 2020- Teverse.com
-- Used to share variables between scripts

return {
    workshop = nil, -- Holds workshop instance and is set in main.lua
    user = nil, -- Holds user instance and is set in main.lua
    developerMode = false, -- Holds the developer_mode boolean and is set in main.lua
    sideBarPageDefault = nil, -- Holds the default sidebar page (view) as a string and is set in topbarInterface.lua
    sideBarPageActive = nil, -- Holds the current active sidebar page (view) as a string and is set in topbarInterface.lua
    defaultColours = { -- Default colors used for theming UI components (~\library\ui\components)
        primary = colour:fromRGB(112, 112, 112),
        secondary = colour:fromRGB(239, 239, 239),
        background = colour:fromRGB(33, 33, 33),
        red = colour:fromRGB(255, 82, 82),
        green = colour:fromRGB(105, 240, 174),
        yellow = colour:fromRGB(255, 215, 64),
        blue = colour:fromRGB(68, 138, 255),
        orange = colour:fromRGB(255, 171, 64),
        purple = colour:fromRGB(124, 77, 255),
        white = colour:fromRGB(255, 255, 255)
    }
}