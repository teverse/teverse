-- Shows the range of colours of the current frame

local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local container = ui.create("guiFrame", shared.workshop.interface, {
   size = guiCoord(1, -20, 1, 0),
   position = guiCoord(0, 10, 0, 10)
}, "background")

ui.create("guiTextBox", container, {
   size = guiCoord(0.25, -10, 0.5, -10),
   position = guiCoord(0, 5, 0, 5),
   text = "Primary"
}, "primary")

ui.create("guiTextBox", container, {
   size = guiCoord(0.25, -10, 0.5, -10),
   position = guiCoord(0.25, 5, 0, 5),
   text = "Primary Variant"
}, "primaryVariant")

ui.create("guiTextBox", container, {
   size = guiCoord(0.25, -10, 0.5, -10),
   position = guiCoord(0.5, 5, 0, 5),
   text = "Secondary"
}, "secondary")

ui.create("guiTextBox", container, {
   size = guiCoord(0.25, -10, 0.5, -10),
   position = guiCoord(0.75, 5, 0, 5),
   text = "Secondary Variant"
}, "secondaryVariant")

ui.create("guiTextBox", container, {
   size = guiCoord(0.5, -10, 0.5, -10),
   position = guiCoord(0, 5, 0.5, 5),
   text = "Error"
}, "error")

ui.create("guiTextBox", container, {
   size = guiCoord(0.5, -10, 0.5, -10),
   position = guiCoord(0.5, 5, 0.5, 5),
   text = "background"
}, "background")

return container