--[[
    Copyright 2019 Teverse
    @File core/server/loader.lua
    @Author(s) Jay
    @Description Loads all open sourced components of the server.
--]]

local chat = require("tevgit:core/server/chat.lua")
local char = require("tevgit:core/server/characterController.lua")

-- Purely for testing purposes only:
while wait(.8) do
		local block = engine.construct("block", workspace, {size = vector3(1,1,1), position = vector3(0,15,0), static=false, colour = colour(math.random(),math.random(),math.random())})
end