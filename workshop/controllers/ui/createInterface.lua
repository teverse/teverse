-- Copyright 2020 Teverse.com
-- Responsible for creating the workshop interface

local shared = require("tevgit:workshop/controllers/shared.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")

require("tevgit:workshop/controllers/ui/components/topBar.lua")
require("tevgit:workshop/controllers/ui/components/toolBar.lua")
require("tevgit:workshop/controllers/ui/components/inserter.lua")

shared.windows.settings = require("tevgit:workshop/controllers/ui/components/settings.lua")
shared.windows.settings.visible = false -- Dont show the window on start, thats annoying

shared.windows.runLua = require("tevgit:workshop/controllers/ui/components/runLua.lua")
shared.windows.runLua.visible = false

shared.windows.propertyEditor = require("tevgit:workshop/controllers/ui/components/propertyEditor/window.lua").window

shared.windows.hierarchy = require("tevgit:workshop/controllers/ui/components/hierarchy.lua").window

shared.windows.history = require("tevgit:workshop/controllers/ui/components/historyUi.lua")
shared.windows.history.visible = false

shared.windows.publish = require("tevgit:workshop/controllers/ui/components/publish.lua")
shared.windows.publish.visible = false

require("tevgit:workshop/controllers/ui/core/dock.lua").loadDockSettings()

if not shared.developerMode then
    ui.prompt("This is community driven software\nIt does not resemble the final product in anyway.", true)
end