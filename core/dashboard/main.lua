local ui = require("tevgit:core/dashboard/ui.lua")

if teverse.dev.localTevGit then
    teverse.construct("guiIcon", {
        parent = teverse.interface,
        size = guiCoord(0, 16, 0, 16),
        position = guiCoord(1, -26, 1, -26),
        iconId = "redo-alt",
        iconType = "faSolid",
        iconColour = colour(0, 0, 0),
        iconMax = 10,
        strokeRadius = 4,
        strokeAlpha = 0.5,
        backgroundAlpha = 1,
        zIndex = 1000
    }):on("mouseLeftUp", function()
        teverse.apps:loadDashboard()
    end)
end

ui.setup()