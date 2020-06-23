-- Copyright 2020- Teverse.com
-- Used to share variables between scripts

return {
    dev = nil, -- Holds workshop instance and is set in main.lua
    user = nil, -- Holds user instance and is set in main.lua
    developerMode = false, -- Holds the developer_mode boolean and is set in main.lua
    sideBarPageDefault = nil, -- Holds the default sidebar page (view) as a string and is set in topbarInterface.lua
    sideBarPageActive = nil, -- Holds the current active sidebar page (view) as a string and is set in topbarInterface.lua
    commandBarTriggers = {},
    defaultColours = { -- Default colors used for theming UI components (~\library\ui\components)
        --primary = colour.rgb(112, 112, 112),
        primary = colour.rgb(52, 58, 64),
        secondary = colour.rgb(239, 239, 239),
        background = colour.rgb(33, 33, 33),
        red = colour.rgb(255, 82, 82),
        green = colour.rgb(105, 240, 174),
        yellow = colour.rgb(255, 215, 64),
        blue = colour.rgb(68, 138, 255),
        orange = colour.rgb(255, 171, 64),
        purple = colour.rgb(124, 77, 255),
        white = colour.rgb(255, 255, 255),
        black = colour(0, 0, 0)
    }
}