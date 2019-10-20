-- Copyright 2019 Teverse.com
-- Responsible for creating the workshop interface

local shared = require("tevgit:workshop/controllers/shared.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")

require("tevgit:workshop/controllers/ui/components/topBar.lua")
require("tevgit:workshop/controllers/ui/components/toolBar.lua")

shared.windows.settings = require("tevgit:workshop/controllers/ui/components/settingsWindow.lua")