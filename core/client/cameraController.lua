--[[
    Copyright 2019 Teverse
    @File core/client/cameraController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.camera = workspace.camera
local target = nil
controller.setTarget = function(t)
	--temp:
	target = t
	controller.camera.position = target.position + vector3(0,10,-30)
	controller.camera:lookAt(target.position)
end

engine.graphics:frameDrawn(function ()
	if target then
		--controller.camera.position = target.position + vector3(0,10,30)
		local newPos = target.position + vector3(0,10,-30)
		local newRot = controller.camera.rotation:setLookRotation( newPos - target.position )
		controller.camera.position = newPos
		controller.camera.rotation = newRot
		--engine.tween:begin(controller.camera, 0.05, {position = newPos, rotation=newRot}, "inOutQuad") --Tween to prevent jiterring.
	end
end)

return controller