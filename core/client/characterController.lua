--[[
    Copyright 2019 Teverse
    @File core/client/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.character = nil -- server creates this

local function setupCharacterLocally(client, char)
	local nameTag = engine.construct("guiTextBox", engine.interface, {
		name = client.id,
		size = guiCoord(0,100,0,16),
		align = enums.align.middle,
		text = client.name,
		alpha = 0,
		fontSize = 16,
		fontFile = "OpenSans-SemiBold.ttf"
	})

	char:changed(function(property, value)
		if property == "position" then
			local inFrontOfCamera, screenPos = workspace.camera:worldToScreen(value + vector3(0,char.size.y/2,0))
			if inFrontOfCamera then
				nameTag.visible = true
				nameTag.position = guiCoord(0, screenPos.x - 50, 0, screenPos.y)
			else
				nameTag.visible = false
			end
		end
	end)
end

local function characterSpawnedHandler(newClientId)
	if engine.networking.me.id == newClientId then
		print("Waiting for character to spawn in workspace ",engine.networking.me.id)
		repeat wait() until workspace[engine.networking.me.id]
		print("Spawned. ",engine.networking.me.id)
		controller.character = workspace[engine.networking.me.id]
		setupCharacterLocally(engine.networking.me, controller.character)
	--	controller.character.physics=false
		if controller.camera then
		--	controller.character.opacity = 0
			--controller.camera.camera.position = vector3(0,90,0)
			--controller.camera.camera:lookAt(vector3(0,0,0))
			controller.camera.setTarget(controller.character)
		end
	else
		repeat wait() until workspace[newClientId]
		local client = engine.networking.clients:getClientFromId(newClientId)
		setupCharacterLocally(client, workspace[newClientId])
	end
end

for _,v in pairs(engine.networking.clients) do
	characterSpawnedHandler(v.id)
end

engine.networking.clients:clientConnected(function (client)
	characterSpawnedHandler(client.id)
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
			totalForce = totalForce + controller.keyBindsDir[i]
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