local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local reference = {
    [1] = {"primary","primaryVariant","primaryText","primaryImage"},
    [2] = {"secondary","secondaryVariant","secondaryText","secondaryImage"},
    [3] = {"error","errorText","errorImage"},
    [4] = {"background","backgroundText","backgroundImage"}
}
local colors = {} -- cached values
local x, y = 70, 70

local container = ui.create("guiScrollView", shared.workshop.interface, {
    size = guiCoord(1, -20, 1, 0),
    position = guiCoord(0, 10, 0, 10),
}, "background")

ui.create("guiTextBox", container, {
    size = guiCoord(1, -30, 0, 20),
    position = guiCoord(0, 15, 0, 15),
    text = "Theme Editor"
},"backgroundText")

-- header title example
ui.create("guiTextBox", container, {
    size = guiCoord(1, -30, 0, 20),
    position = guiCoord(0, 40, 0, 40),
    text = "Primary Colors",
    fontSize = 16,
    readOnly = true,
    wrap = true,
},"backgroundText")


--[[
-- Primary Color Format Thing I think lol
for i,v in pairs(reference) do
    -- create header title here
    ui.create("guiTextBox", container, {
        size = guiCoord(0, 30, 0, 20),
        position = guiCoord(0, 40, 0, 40),
        text = "test",
        fontSize = 16,
        readOnly = true,
        wrap = true,
    },"backgroundText")
    for k,m in pairs(v) do
        -- ColorFrames
        ui.create("guiFrame", container, {
            size = guiCoord(0, 15, 0, 15),
            position = guiCoord(0, x, 0, y),
        },m)
        y = y + 30
    end
end
]]--


-- Primary Section
-- probably should bind into a method; testing

-- Primary ColorFrames
ui.create("guiFrame", container, {
    size = guiCoord(0, 15, 0, 15),
    position = guiCoord(0, 70, 0, 70),
},"primary")

ui.create("guiFrame", container, {
    size = guiCoord(0, 15, 0, 15),
    position = guiCoord(0, 70, 0, 100),
},"primaryVariant")

ui.create("guiFrame", container, {
    size = guiCoord(0, 15, 0, 15),
    position = guiCoord(0, 70, 0, 130),
    visible = true,
},"primaryText")

ui.create("guiFrame", container, {
    size = guiCoord(0, 15, 0, 15),
    position = guiCoord(0, 70, 0, 160),
},"primaryImage")


-- Primary Textboxes
ui.create("guiTextBox", container, {
    size = guiCoord(1, -30, 0, 20),
    position = guiCoord(0, 100, 0, 70),
    text = "Primary :",
    fontSize = 14,
    readOnly = true,
    wrap = true,
},"backgroundText")

ui.create("guiTextBox", container, {
    size = guiCoord(1, -30, 0, 20),
    position = guiCoord(0, 100, 0, 100),
    text = "Primary Variant :",
    fontSize = 14,
    readOnly = true,
    wrap = true,
},"backgroundText")

ui.create("guiTextBox", container, {
    size = guiCoord(1, -30, 0, 20),
    position = guiCoord(0, 100, 0, 130),
    text = "Primary text :",
    fontSize = 14,
    readOnly = true,
    wrap = true,
},"backgroundText")

ui.create("guiTextBox", container, {
    size = guiCoord(1, -30, 0, 20),
    position = guiCoord(0, 100, 0, 160),
    text = "Primary Image :",
    fontSize = 14,
    readOnly = true,
    wrap = true,
},"backgroundText")


-- Secondary Section

-- header title
ui.create("guiTextBox", container, {
    size = guiCoord(1, -30, 0, 20),
    position = guiCoord(0, 40, 0, 185),
    text = "Secondary Colors",
    fontSize = 16,
    readOnly = true,
    wrap = true,
},"backgroundText")











return container