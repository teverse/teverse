--[[
    Copyright 2019 Teverse
    @File core/server/loader.lua
    @Author(s) Jay
    @Description Loads all open sourced components of the server.
--]]
require("tevgit:core/server/debug.lua")

local chat = require("tevgit:core/server/chat.lua")
--local char = require("tevgit:core/server/characterController.lua")

-- Purely for testing purposes only:
--[[
for x = 6,9 do
	for y = 2,6 do
		for z = 0,4 do
			local block = engine.construct("block", workspace, {
				size = vector3(1,1,1), 
				position = vector3(x,y,z), 
				static=false, 
				colour = colour(math.random(),math.random(),math.random())
			})
			wait()
		end
	end
end]]