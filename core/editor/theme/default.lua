-- This file uses colours from https://ethanschoonover.com/solarized/

local colours = {
    Base0   = colour.rgb(131, 148, 150),
    Base1   = colour.rgb(147, 161, 161),
    Base2   = colour.rgb(238, 232, 213),
    Base3   = colour.rgb(253, 246, 227),
    
    Base00  = colour.rgb(101, 123, 131),
    Base01  = colour.rgb(88, 110, 117),
    Base02  = colour.rgb(7, 54, 66),
    Base03  = colour.rgb(0, 43, 54),

    Yellow  = colour.rgb(181, 137, 0),
    Orange  = colour.rgb(203, 75, 22),
    Red     = colour.rgb(220, 50, 47),
    Magenta = colour.rgb(211, 54, 130),
    Violet  = colour.rgb(108, 113, 196),
    Blue    = colour.rgb(38, 139, 210),
    Cyan    = colour.rgb(42, 161, 152),
    Green   = colour.rgb(133, 153, 0),
}

return {
    background      = colours.Base03,
    foreground      = colours.Base0,
    highlighted     = colours.Base02,

    comment         = colours.Base01,
    string_start    = colours.Cyan,
    string_end      = colours.Cyan,
    string          = colours.Cyan,
    escape          = colours.Blue,
    keyword         = colours.Magenta,
    value           = colours.Green,
    ident           = colours.Blue,
    number          = colours.Magenta,
    symbol          = colours.Base1,
    vararg          = colours.Red,
    operator        = colours.Green,
    label_start     = colours.Red,
    label_end       = colours.Red,
    label           = colours.Red,
    unidentified    = colours.Base01
}