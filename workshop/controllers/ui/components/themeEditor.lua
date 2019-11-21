-- Copyright 2019 Teverse

local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")
local currentTheme = require("tevgit:workshop/controllers/ui/themes/default.lua")

-- Structure Mappings
local mappings = {
    ["Labels"] = {
        "primary",
        "primaryVariant",
        "primaryText",
        "primaryImage",
        "secondary",
        "secondaryVariant",
        "secondaryText",
        "secondaryImage",
        "error",
        "errorText",
        "errorImage",
        "background",
        "backgroundText",
        "backgroundImage",
    },
    ["Indexes"] = {} -- Stores button references
}

-- Positional Vars
local lx,ly = 0.1,0.07


local container = ui.create("guiFrame", shared.workshop.interface, {
   size = guiCoord(1, -20, 1, 0),
   position = guiCoord(0, 10, 0, 10)
}, "background")

ui.create("guiTextBox", container, {
    size = guiCoord(0.25, -10, 0.5, -10),
    position = guiCoord(0, 0, 0, 0),
    text = "Theme Editor"
}, "backgroundText")

-- Generate vertical list
for l,k in pairs(mappings["Labels"]) do

    -- Create colored frame from mappings
    ui.create("guiFrame", container, {
        size = guiCoord(0.05, 0, 0.035, 0),
        position = guiCoord(lx, 0, ly, 0),
        borderAlpha = 1,
        borderColour = colour(1,1,1),
        borderRadius = 3,
        backgroundAlpha = 1,
    }, k)

    -- Create Current Value from mappings
    ui.create("guiTextBox", container, {
        size = guiCoord(0.05, 0, 0.035, 0),
        position = guiCoord(lx+0.07, 0, ly, 0),
        text = (k:gsub("%a", string.upper, 1)), -- Might be overkill but, it's visually pleasing
        fontSize = 18,
    },"background")

        
    -- Create Edit Value Button from mappings
    local size = guiCoord(0.08, 0, 0.03, 0)
    local position = guiCoord(lx+0.4, 0, ly+0.008, 0)
    local editButton = ui.customButton(container,"EDIT",size,position,enums.align.middle,10,"primary")

    editButton:mouseLeftPressed(function()
        -- Invoke color change menu, wip
        -- Change Key[Value] in default theme
        print("Button Clicked!")
    end)


    ly = ly + 0.05
end

-- Save Button
=======
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