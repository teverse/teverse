--[[
    Copyright 2019 Teverse
    @File core/client/cameraController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.camera = workspace.camera
local target = nil

controller.setTarget = function(t)
	target = t
	controller.camera.position = target.position + vector3(0,20,-30)
	controller.camera:lookAt(target.position)

	target:changed(function ()
		controller.camera.position = target.position + vector3(0,20,-30)
		controller.camera:lookAt(target.position)
	end)
end




return controller