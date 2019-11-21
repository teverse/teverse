-- Copyright 2019 Teverse.com
-- Responsible for creating the workshop interface

local shared = require("tevgit:workshop/controllers/shared.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")

require("tevgit:workshop/controllers/ui/components/topBar.lua")
require("tevgit:workshop/controllers/ui/components/toolBar.lua")

shared.windows.settings = require("tevgit:workshop/controllers/ui/components/settings.lua")
shared.windows.settings.visible = true -- Dont show the window on start, thats annoying

shared.windows.runLua = require("tevgit:workshop/controllers/ui/components/runLua.lua")
shared.windows.runLua.visible = false
