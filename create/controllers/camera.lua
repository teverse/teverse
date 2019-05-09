-- Copyright (c) 2019 teverse.com
-- camera.lua

local cameraController = {}
local selectionController = require("tevgit:create/controllers/select.lua")

cameraController.zoomStep = 3
cameraController.rotateStep = -0.0045
cameraController.moveStep = 0.5 -- how fast the camera moves

cameraController.camera = workspace.camera

-- Setup the initial position of the camera
cameraController.camera.position = vector3(11, 5, 10)
cameraController.camera:lookAt(vector3(0,0,0))
-- Camera key input values
cameraController.cameraKeyEventLooping = false
cameraController.cameraKeyArray = {
	[enums.key.w] = vector3(0, 0, -1),
	[enums.key.s] = vector3(0, 0, 1),
	[enums.key.a] = vector3(-1, 0, 0),
	[enums.key.d] = vector3(1, 0, 0),
	[enums.key.q] = vector3(0, -1, 0),
	[enums.key.e] = vector3(0, 1, 0)
}

engine.input:mouseScrolled(function( input )
	if input.systemHandled then return end

	local cameraPos = cameraController.camera.position
	cameraPos = cameraPos + (cameraController.camera.rotation * (cameraController.cameraKeyArray[enums.key.w] * input.movement.y * cameraController.zoomStep))
	cameraController.camera.position = cameraPos	

end)

engine.input:mouseMoved(function( input )
	if engine.input:isMouseButtonDown( enums.mouseButton.right ) then
		local pitch = quaternion():setEuler(input.movement.y * cameraController.rotateStep, 0, 0)
		local yaw = quaternion():setEuler(0, input.movement.x * cameraController.rotateStep, 0)

		-- Applied seperately to avoid camera flipping on the wrong axis.
		cameraController.camera.rotation = yaw * cameraController.camera.rotation;
		cameraController.camera.rotation = cameraController.camera.rotation * pitch
		
		--updatePosition()
	end
end)

engine.input:keyPressed(function( inputObj )
	if inputObj.systemHandled then return end

	if cameraController.cameraKeyArray[inputObj.key] and not cameraController.cameraKeyEventLooping then
		cameraController.cameraKeyEventLooping = true
		repeat
			local cameraPos = cameraController.camera.position

			for key, vector in pairs(cameraController.cameraKeyArray) do
				-- check this key is pressed (still)
				if engine.input:isKeyDown(key) then
					cameraPos = cameraPos + (cameraController.camera.rotation * vector * cameraController.moveStep)
				end
			end

			cameraController.cameraKeyEventLooping = (cameraPos ~= cameraController.camera.position)
			cameraController.camera.position = cameraPos	

			wait(0.001)

		until not cameraController.cameraKeyEventLooping
	end

	-- SELECTION SYSTEM REQUIRED
	--[[
	if inputObj.key == enums.key.f and #selectionController.selection>0 then
		local mdn = vector3(median(selectionController.selection, "x"), median(selectionController.selection, "y"),median(selectionController.selection, "z") )
		--camera.position = mdn + (camera.rotation * vector3(0,0,1) * 15)
		--print(mdn)
		engine.tween:begin(cameraController.camera, .2, {position = mdn + (cameraController.camera.rotation * vector3(0,0,1) * 15)}, "outQuad")

	end]]
end)

return cameraController