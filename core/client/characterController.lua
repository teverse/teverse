--[[
    Copyright 2019 Teverse
    @File core/client/characterController.lua
    @Author(s) Jay
--]]

print("loading chars")

local controller = {}

-- set to false for debugging purposes.
local CLIENT_PREDICTION = true

controller.character = nil -- server creates this
controller.camera = require("tevgit:core/client/cameraController.lua")

local forward = quaternion:setEuler(0, controller.camera.cameraRotation:getEuler().y, 0)

local function setupCharacterLocally(client, char)
	local nameTag = engine.construct("guiTextBox", engine.interface, {
		name 			= client.id,
		size 			= guiCoord(0, 100, 0, 16),
		align 			= enums.align.middle,
		text 			= client.name,
		textColour 		= colour(1, 1, 1),
		backgroundAlpha = 0,
		fontSize 		= 16,
		fontFile 		= "OpenSans-SemiBold.ttf"
	})

	workspace.camera:onSync("changed", function()
		local inFrontOfCamera, screenPos = workspace.camera:worldToScreen(char.position + vector3(0,char.size.y/2,0)) 
		if inFrontOfCamera then
			nameTag.visible = true
			nameTag.position = guiCoord(0, screenPos.x - 50, 0, screenPos.y)
		else
			nameTag.visible = false
		end
	end)
end

local function characterSpawnedHandler(newClientId)
	if engine.networking.me.id == newClientId then
		repeat wait() until workspace[engine.networking.me.id]

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

for _,v in pairs(engine.networking.clients.children) do
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
			totalForce = totalForce + (forward * controller.keyBindsDir[i])
		end
	end

	if CLIENT_PREDICTION and moved then


		--controller.character:applyImpulse(totalForce * 10)
		local f = totalForce*10
		f.y = controller.character.velocity.y
		local lv = vector3(f.x, 0, f.z)
		if lv ~= vector3(0,0,0) then
			controller.character.rotation = quaternion:setLookRotation(lv)
		end
		controller.character.velocity = f

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
		print("Predicting")
		engine.graphics:onSync("frameDrawn",function()
			if not updatePrediction() then
				print("Ending prediction")
				isPredicting =false
				self:disconnect() -- no input from user.
			end
		end)
	end
end

engine.input:keyPressed(function (inputObj)
	if controller.keyBinds[inputObj.key] then
		forward = quaternion:setEuler(0, controller.camera.cameraRotation:getEuler().y + math.rad(180), 0)
		predictServerMovementOnClient(controller.keyBinds[inputObj.key])
		engine.networking:toServer("characterSetInputStarted", controller.keyBinds[inputObj.key], controller.camera.cameraRotation)
	end
end)

engine.input:keyReleased(function (inputObj)
	if controller.keyBinds[inputObj.key]  then
		engine.networking:toServer("characterSetInputEnded", controller.keyBinds[inputObj.key])
		controller.keys[controller.keyBinds[inputObj.key]] = false
	end
end)

return controller