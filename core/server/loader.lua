--[[
    Copyright 2019 Teverse
    @File core/server/loader.lua
    @Author(s) Jay
    @Description Loads all open sourced components of the server.
--]]

local chat = require("tevgit:core/server/chat.lua")
local char = require("tevgit:core/server/characterController.lua")

-- Purely for testing purposes only:
while wait(1) do
	local blocks = {}
	for x = 1, 5 do
		for i = 1,5 do
			local block = engine.construct("block", workspace, {size = vector3(1,1,1), position = vector3(x,i,0), static=false, colour = colour(math.random(),math.random(),math.random())})
			table.insert(blocks, block)
		end
		wait()
	end

	wait(10)

	for _,v in pairs(blocks) do v:destroy() end
end