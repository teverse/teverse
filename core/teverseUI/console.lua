local container = teverse.construct("guiFrame", {
    parent = teverse.coreInterface,
    size = guiCoord(0.1, 150, 0.4, 200),
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
    textSize = 20,
    textAlign = "middleLeft",
    text = "Console"
})

local logContainer = teverse.construct("guiScrollView", {
    parent = container,
    size = guiCoord(1, -10, 1, -10),
    position = guiCoord(0, 5, 0, 20),
    backgroundAlpha = 0.0,
    canvasSize = guiCoord(1, -1, 10, 0) 
})

local lastPos = 0
function addLog (msg, time)
    local txt = teverse.construct("guiTextBox", {
        parent = logContainer,
        size = guiCoord(1, -10, 0, 25),
        position = guiCoord(0, 5, 0, lastPos),
        backgroundAlpha = 0,
        strokeAlpha = 0,
        textWrap = true,
        clip = false
    })
    txt.text = os.date("%H:%M:%S", time) .. " : " .. msg
    txt.size = guiCoord(1, -10, 0, txt.textDimensions.y)
    lastPos = lastPos + txt.textDimensions.y + 3

    -- Update container size
    logContainer.canvasSize = guiCoord(1, -1, 0.5, lastPos)
end
-- TODO: Warn/error detection & colours
teverse.debug:on("print", function(msg)
    pcall(function()
        addLog(msg)
    end)
end)

if _TEV_VERSION_PATCH and _TEV_VERSION_PATCH >= 9 then
    for _,v in pairs(teverse.debug:getOutputHistory()) do
        addLog(v.message, v.time)
    end
else
    print("History not supported")
end


return container