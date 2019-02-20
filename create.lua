 -- Copyright (c) 2019 teverse.com
 -- create mode

 -- This script should get access to 'engine.workshop' APIs.


-- Setup Start Enviroment
engine.graphics.clearColour = colour:fromRGB(155, 181, 242)
engine.graphics.ambientColour = colour:fromRGB(166, 166, 166)

local directionalLight = engine.light("light1")	
directionalLight.offsetPosition = vector3(3,4,0)	
directionalLight.parent = workspace	
directionalLight.type = enums.lightType.directional
directionalLight.offsetRotation = quaternion():setEuler(-.2,0.2,0)
directionalLight.shadows = true

local basePlate = engine.block("base")
basePlate.colour = colour(1, 1, 1)
basePlate.size = vector3(100, 1, 100)
basePlate.position = vector3(0, -1, 0)
basePlate.parent = workspace

local starterBlock = engine.block("block")
starterBlock.colour = colour(0.5, 0.5, 0.2)
starterBlock.size = vector3(1,1,1)
starterBlock.position = vector3(0, 0, 0)
starterBlock.parent = workspace

-- Camera

local zoomStep = 3
local rotateStep = -0.0045
local moveStep = 0.5 -- how fast the camera moves

local camera = workspace.camera

-- Setup the initial position of the camera
camera.position = vector3(11, 5, 10)
camera:lookAt(vector3(0,0,0))
-- Camera key input values
local cameraKeyEventLooping = false
local cameraKeyArray = {
	[enums.key.w] = vector3(0, 0, -1),
	[enums.key.s] = vector3(0, 0, 1),
	[enums.key.a] = vector3(-1, 0, 0),
	[enums.key.d] = vector3(1, 0, 0),
	[enums.key.q] = vector3(0, -1, 0),
	[enums.key.e] = vector3(0, 1, 0)
}

engine.input:mouseScrolled(function( input )
	if input.systemHandled then return end

	local cameraPos = camera.position
	cameraPos = cameraPos + (camera.rotation * (cameraKeyArray[enums.key.w] * input.movement.y * zoomStep))
	camera.position = cameraPos	

end)

engine.input:mouseMoved(function( input )
	if engine.input:isMouseButtonDown( enums.mouseButton.right ) then
		local pitch = quaternion():setEuler(input.movement.y * rotateStep, 0, 0)
		local yaw = quaternion():setEuler(0, input.movement.x * rotateStep, 0)

		-- Applied seperately to avoid camera flipping on the wrong axis.
		camera.rotation = yaw * camera.rotation;
		camera.rotation = camera.rotation * pitch
		
		--updatePosition()
	end
end)

engine.input:keyPressed(function( inputObj )
	if inputObj.systemHandled then return end

	if cameraKeyArray[inputObj.key] and not cameraKeyEventLooping then
		cameraKeyEventLooping = true
		repeat
			local cameraPos = camera.position

			for key, vector in pairs(cameraKeyArray) do
				-- check this key is pressed (still)
				if engine.input:isKeyDown(key) then
					cameraPos = cameraPos + (camera.rotation * vector * moveStep)
				end
			end

			cameraKeyEventLooping = (cameraPos ~= camera.position)
			camera.position = cameraPos	

			wait(0.001)

		until not cameraKeyEventLooping
	end
end)
