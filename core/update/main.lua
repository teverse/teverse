local main = teverse.construct("guiFrame", {
    parent = teverse.interface,
    backgroundColour = colour.rgb(52, 58, 64),
    size = guiCoord(1, 0, 1, 100),
    position = guiCoord(0, 0, 0, -50)
})

teverse.construct("guiImage", {
    position = guiCoord(0.5, -750, 0.5, -750),
    size = guiCoord(0, 1500, 0, 1500),
    parent = main,
    backgroundAlpha = 0,
    image = "tevurl:img/tTiled.png",
    imageBottomRight = vector2(90, 90),
    imageColour = colour:rgb(28, 33, 38),
    imageAlpha = 0.25,
    zIndex = -1
})

local dialog = teverse.construct("guiFrame", {
    parent = main,
    size = guiCoord(0, 200, 0, 100),
    position = guiCoord(0.5, -100, 0.5, -50),
    backgroundColour = colour(1, 1, 1),
    strokeAlpha = 0,
    strokeRadius = 3
})

local gui = teverse.construct("guiTextBox", {
    parent = dialog,
    size = guiCoord(0.8, 0, 0, 40),
    position = guiCoord(0.1, 0, 0, 5),
    backgroundAlpha = 0,
    text = "teverse",
    textSize = 40,
    textAlign = enums.align.middle,
    textColour = colour.rgb(61, 66, 71),
    textFont = "tevurl:fonts/moskUltraBold.ttf"
})

local gui = teverse.construct("guiTextBox", {
    parent = dialog,
    size = guiCoord(0.8, 0, 1, -50),
    position = guiCoord(0.1, 0, 0, 50),
    backgroundAlpha = 0,
    text = "An update is in progress\nPlease be patient",
    textWrap = true,
    textSize = 16,
    textAlign = enums.align.topMiddle,
    textColour = colour.rgb(61, 66, 71)
})

local progressBar = teverse.construct("guiFrame", {
    parent = dialog,
    size = guiCoord(0, 0, 0, 5),
    position = guiCoord(0, 0, 1, -5),
    backgroundColour = colour.rgb(74, 140, 122)
})

if _OS == "OSX" or _OS == "IOS" then
    -- We distribute updates via the app store on iOS/OSX
    gui.text = "A new version is available, please check the App Store."
end

teverse.networking:on("_update", function(message)
    print('got ', message)
    gui.text = message
end)

teverse.networking:on("_downloadProgress", function(str)
    local pcnt = tonumber(str)
    progressBar.size = guiCoord(pcnt/100, 0, 0, 5)
end)