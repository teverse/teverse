--[[
    Copyright 2019 Teverse
    @File core/client/loader.lua
    @Author(s) Jay
    @Description Loads all open sourced components of the client.
--]]

engine.networking:connected(function (serverId)
	require("tevgit:core/client/chat.lua")
	require("tevgit:core/client/playerList.lua")
	local characterController = require("tevgit:core/client/characterController.lua")
	local cameraController = require("tevgit:core/client/cameraController.lua")
	cameraController.setTarget(characterController.character)
end)

