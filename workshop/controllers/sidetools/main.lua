-- Copyright 2020 Teverse.com
-- This script is responsible for loading in the other sidetools
-- This is required by the UI system and the array returned is used to generate the sidebar

return {
    handTool   = require("tevgit:workshop/controllers/sidetools/hand.lua"),
    moveTool   = require("tevgit:workshop/controllers/sidetools/move.lua"),
    scaleTool  = require("tevgit:workshop/controllers/sidetools/scale.lua"),
    --rotateTool = require("tevgit:workshop/controllers/sidetools/rotate.lua"),
}
