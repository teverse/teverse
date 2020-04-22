local main = teverse.construct("guiFrame", {
    parent = teverse.interface,
    backgroundColour = colour.rgb(52, 58, 64),
    size = guiCoord(1, 0, 1, 100),
    position = guiCoord(0, 0, 0, -50)
})

teverse.construct("guiImage", {
    position = guiCoord(0.5, -1500, 0.5, -750),
    size = guiCoord(0, 3000, 0, 1500),
    parent = main,
    backgroundAlpha = 0,
    image = "tevurl:img/tTiled.png",
    imageBottomRight = vector2(180, 90),
    imageColour = colour:rgb(28, 33, 38),
    imageAlpha = 0.25,
    zIndex = -1
})

local gui = teverse.construct("guiTextBox", {
    parent = main,
    size = guiCoord(0.8, 0, 0, 70),
    position = guiCoord(0.1, 0, 0.5, -35),
    backgroundAlpha = 0,
    text = "teverse",
    textSize = 70,
    textAlign = enums.align.middle,
    textShadowSize = 2,
    textColour = colour(1, 1, 1),
    textFont = "tevurl:fonts/moskUltraBold.ttf"
})

local login = teverse.construct("guiTextBox", {
    parent = main,
    size = guiCoord(0, 80, 0, 26),
    position = guiCoord(0.5, -40, 0.5, 45),
    backgroundColour = colour(1, 1, 1),
    text = "Login",
    textFont = "tevurl:fonts/openSansBold.ttf",
    textSize = 24,
    textAlign = enums.align.middle,
    strokeRadius = 3,
    visible = false
})

login.size = guiCoord(0, login.textDimensions.x + 30, 0, 26)
login.position = guiCoord(0.5, -(login.textDimensions.x + 30)/2, 0.5, 45)

local db = false
local listenerid = login:on("mouseLeftDown", function()
    if db then return end
    teverse.openUrl("https://teverse.com/dashboard?client=1")
    login.visible = false
    sleep(2)
    login.visible = true
end)

teverse.networking:on("_localAuthenticating", function(state)
    if state ~= "failed" then
        db = true
        login.text = "Authenticating..."
        login.size = guiCoord(0, login.textDimensions.x + 30, 0, 26)
        login.position = guiCoord(0.5, -(login.textDimensions.x + 30)/2, 0.5, 45)
    else
        db = false
        login.text = "Login"
        login.size = guiCoord(0, login.textDimensions.x + 30, 0, 26)
        login.position = guiCoord(0.5, -(login.textDimensions.x + 30)/2, 0.5, 45)
    end
end)

sleep(1)
login.visible = true

while teverse.networking.localClient == nil do
    sleep(1.5)
end

print("Logged in as " .. teverse.networking.localClient.name)
main:destroy()