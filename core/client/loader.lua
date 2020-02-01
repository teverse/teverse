--[[
    Copyright 2020 Teverse
    @File core/client/loader.lua
    @Author(s) Jay
    @Description Loads all open sourced components of the client.
--]]

print("Loaded Client")
require("tevgit:core/client/debug.lua")
require("tevgit:core/client/chat.lua")
require("tevgit:core/client/playerList.lua")
require("tevgit:core/client/characterController.lua")

workspace.camera.position = vector3(40, 15, 0)
workspace.camera:lookAt(vector3(0, 0, 0))

engine.construct("block", workspace, {
    position = vector3(0, 10, 0),
    static = false,
    colour = colour(0.3, 0.3, 0.3)
})