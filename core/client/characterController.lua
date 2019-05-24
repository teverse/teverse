--[[
    Copyright 2019 Teverse
    @File core/client/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.character = nil -- server creates this

engine.networking:bind( "characterSpawned", function()
	repeat wait() until workspace[engine.networking.me.id]
	controller.character = workspace[engine.networking.me.id]
	if controller.camera then
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
	[enums.key.right] = 4
}

engine.input:keyPressed(function (inputObj)
	if controller.keyBinds[inputObj.key] then
		engine.networking:toServer("characterSetInputStarted", controller.keyBinds[inputObj.key])
	end
end)

engine.input:keyReleased(function (inputObj)
	if controller.keyBinds[inputObj.key]  then
		engine.networking:toServer("characterSetInputEnded", controller.keyBinds[inputObj.key])
	end
end)

--[[controller.update = function()
	local totalForce = vector3()
	local moved = false

	for key, force in pairs(controller.keyBinds) do
		if engine.input:isKeyDown(enums.key[key]) then
			moved=true
			totalForce = totalForce + force
		end
	end
	if moved then
		controller.character:applyForce(totalForce * controller.speed)
	end
end]]

--engine.graphics:frameDrawn(controller.update)

return controller