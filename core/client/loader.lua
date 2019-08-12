--[[
    Copyright 2019 Teverse
    @File core/client/loader.lua
    @Author(s) Jay
    @Description Loads all open sourced components of the client.
--]]

print("Loaded Client")
require("tevgit:core/client/debug.lua")

engine.networking:connected(function (serverId)
	print("Connected")
	require("tevgit:core/client/chat.lua")
	require("tevgit:core/client/playerList.lua")
	local characterController = require("tevgit:core/client/characterController.lua")
end)

