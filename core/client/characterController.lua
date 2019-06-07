--[[
    Copyright 2019 Teverse
    @File core/client/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.character = nil -- server creates this

engine.networking:bind( "characterSpawned", function()
	repeat wait() until workspace[engine.networking.me.id]
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

return controller