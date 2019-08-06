--[[
    Copyright 2019 Teverse
    @File core/client/cameraController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.camera = workspace.camera
local target = nil

controller.cameraRotation = quaternion:setEuler(math.rad(340), 0, 0)
local cameraDistance   = 30

controller.maxDistance = 50
controller.minDistance = 6

controller.setTarget = function(t)
	target = t
	controller.camera.position = target.position + (controller.cameraRotation*vector3(0,0,cameraDistance))
	controller.camera:lookAt(target.position)

	target:changed(function ()
		controller.camera.position = target.position + (controller.cameraRotation*vector3(0,0,cameraDistance))
		controller.camera:lookAt(target.position)
	end)
end

engine.input:on("mouseRightPressed", function ()
	if target then
		local mouseLocation = engine.input.mousePosition
		while engine.input:isMouseButtonDown(enums.mouseButton.right) and wait() do
			local moved = mouseLocation- engine.input.mousePosition
			mouseLocation = engine.input.mousePosition

			local euler = controller.cameraRotation:getEuler()
			euler = euler + vector3(math.rad(moved.y), math.rad(moved.x), 0)
			euler.x = math.clamp(euler.x, math.rad(300), math.rad(359))

			controller.cameraRotation = quaternion:setEuler(euler)

			controller.camera.position = target.position + (controller.cameraRotation*vector3(0,0,cameraDistance))
			controller.camera:lookAt(target.position)
		end
	end
end)

engine.input:on("mouseScrolled", function (inputObj)
	cameraDistance = math.clamp(cameraDistance - (inputObj.movement.y*2), controller.minDistance, controller.maxDistance)
	if target then
		controller.camera.position = target.position + (controller.cameraRotation*vector3(0,0,cameraDistance))
		controller.camera:lookAt(target.position)
	end
end)

return controller