local container = teverse.construct("guiFrame", {
    parent = teverse.coreInterface,
    size = guiCoord(0, 300, 0, 400),
    position = guiCoord(0, 20, 0, 20),
    backgroundAlpha = 0.9,
    zIndex = 1000,
    strokeRadius = 2,
    strokeAlpha = 0.2,
    visible = false
})

teverse.construct("guiTextBox", {
    parent = container,
    size = guiCoord(1, -10, 0, 20),
    position = guiCoord(0, 5, 0, 0),
    backgroundAlpha = 0.0,
    textSize = 16,
    textAlign = "middleLeft",
    text = "Console"
})

local txt = teverse.construct("guiTextBox", {
    parent = container,
    size = guiCoord(1, -10, 1, -25),
    position = guiCoord(0, 5, 0, 20),
    backgroundAlpha = 0.95,
    strokeAlpha = 0.2,
    textWrap = true
})

if _TEV_VERSION_PATCH and _TEV_VERSION_PATCH >= 9 then
    for _,v in pairs(teverse.debug:getOutputHistory()) do
        txt.text = txt.text .. "\n" .. os.date("%H:%M:%S (h)", v.time) .. " : " .. v.message
    end
else
    print("History not supported")
end

teverse.debug:on("print", function(msg)
    txt.text = string.sub(os.date("%H:%M:%S") .. " : " .. msg .. "\n" .. txt.text, 0, 500)
end)

return container