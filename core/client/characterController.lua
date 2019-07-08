--[[
    Copyright 2019 Teverse
    @File core/client/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.character = nil -- server creates this

engine.networking:bind( "characterSpawned", function()
	print("Waiting for character to spawn in workspace ",engine.networking.me.id)
	repeat wait() until workspace[engine.networking.me.id]
	print("Spawned. ",engine.networking.me.id)
		wait(1)
	controller.character = workspace[engine.networking.me.id]

	if controller.camera then
	--	controller.character.opacity = 0
		--controller.camera.camera.position = vector3(0,90,0)
		--controller.camera.camera:lookAt(vector3(0,0,0))
		controller.camera.setTarget(controller.character)
	end
end)

controller.keyBinds = {
	[enums.key.w]  = 1,
	[enums.key.up] = 1,

	[enums.key.s]    = 2,
	[enums.key.down] = 2,

	[enums.key.a]    = 3,
	[enums.key.left] = 3,

	[enums.key.d]     = 4,
	[enums.key.right] = 4,
	
	[enums.key.space] = 5
}

controller.keyBindsDir = {
	vector3(0,0,1), --w
	vector3(0,0,-1), --s
	vector3(1,0,0), --a
	vector3(-1,0,0) -- d
}

controller.keys = {
	false,
	false,
	false,
	false,
	false
}

local isPredicting = false

local updatePrediction = function()
	local totalForce = vector3()
	local moved = false
	for i, pressed in pairs(controller.keys) do
		if pressed then
			moved=true
			totalForce = totalForce + controller.keyBinds[i]
		end
	end

	if moved then
		controller.character:applyForce(totalForce * 500)
	end

	return moved
end

-- The purpose of this function is to predict how the server will move the character
-- based on the input we send.
local function predictServerMovementOnClient(direction)
	if not controller.character then return end

	if direction == 5 then
		controller.character:applyImpulse(0,300,0)
		return nil
	elseif controller.keys[direction] == nil then 
		return nil
	end

	controller.keys[direction] = true
	if not isPredicting then
		isPredicting = true
		engine.graphics:frameDrawn(function()
			if not updatePrediction() then
				isPredicting =false
				self:disconnect() -- no input from user.
			end
		end)
	end
end

engine.input:keyPressed(function (inputObj)
	if controller.keyBinds[inputObj.key] then
		predictServerMovementOnClient(controller.keyBinds[inputObj.key])
		engine.networking:toServer("characterSetInputStarted", controller.keyBinds[inputObj.key])
	end
end)

engine.input:keyReleased(function (inputObj)
	if controller.keyBinds[inputObj.key]  then
		engine.networking:toServer("characterSetInputEnded", controller.keyBinds[inputObj.key])
		controller.keys[controller.keyBinds[inputObj.key]] = false
	end
end)

return controller