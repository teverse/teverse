-- Copyright 2020- Teverse
-- This script is required when workshop is loaded & acts as the 3D Camera for the 3D Environment

local keyMap = {
    [tonumber(enums.keys.KEY_W)] = vector3(0, 0, 1),
    [tonumber(enums.keys.KEY_S)] = vector3(0, 0, -1),
    [tonumber(enums.keys.KEY_A)] = vector3(-1, 0, 0),
    [tonumber(enums.keys.KEY_D)] = vector3(1, 0, 0),
    [tonumber(enums.keys.KEY_Q)] = vector3(0, -1, 0),
    [tonumber(enums.keys.KEY_E)] = vector3(0, 1, 0)
}

local moveStep = 0.3
local rotateStep = 0.01

local cam = teverse.scene.camera
local db = false

teverse.input:on("keyDown", function(key)
    local mapped = keyMap[tonumber(key)]
    if mapped then
        while sleep() and teverse.input:isKeyDown(key) do
            cam.position = cam.position + (cam.rotation * mapped * moveStep)
        end
    end
end)

teverse.input:on("mouseMoved", function( movement )
    if teverse.input:isMouseButtonDown(3) then
		local pitch = quaternion.euler(movement.y * rotateStep, 0, 0)
		local yaw = quaternion.euler(0, movement.x * rotateStep, 0)

		-- Applied seperately to avoid camera flipping on the wrong axis.
		cam.rotation = yaw * cam.rotation;
		cam.rotation = cam.rotation * pitch
	end
end)