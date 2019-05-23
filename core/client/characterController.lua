--[[
    Copyright 2019 Teverse
    @File core/client/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.character = engine.construct("block", workspace, {
	size = vector3(2,3,1),
	colour = colour3(math.random(),math.random(),math.random())
	position = vector3(0,10,0),
})

return controller