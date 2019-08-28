--[[
    Copyright 2019 Teverse
    @File core/server/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.defaultSpeed = 50
controller.characters = {}
controller.chat = nil

update = function(client, cameraDirection)
	local totalForce = vector3()
	local moved = false
	for i, pressed in pairs(controller.characters[client].keys) do
		if pressed then
			moved=true
			totalForce = totalForce + (cameraDirection * controller.keyBinds[i])
		end
	end

	if moved then
		--controller.characters[client].character:applyImpulse(totalForce * 10)
		local f = totalForce*10
		f.y = controller.characters[client].character.velocity.y
		local lv = vector3(f.x, 0, f.z)
		if lv ~= vector3(0,0,0) then
			controller.characters[client].character.rotation = quaternion:setLookRotation(lv)
		end
		controller.characters[client].character.velocity = f
	end

	return moved
end

engine.networking.clients:clientConnected(function (client)
	wait(1)
	print("spawning", client.id)
	local char = engine.construct("block", workspace, {
		name 		  	= client.id,
		size 		  	= vector3(3, 4, 1.5),
		colour 		  	= colour:random(),
		position 	  	= vector3(0, 20, 0),
		static 		  	= false,
		rollingFriction	= 1.5,
		spinningFriction = 1.5,
		friction = 1.5,
		linearDamping = 0.5,
	--	mesh = "primitive:sphere", 
		angularFactor 	= vector3(0, 0, 0)
	})

	--engine.networking:toAllClients("characterSpawned", client.id)

	local fallen = false
	char:changed(function(property, value)
		if property == "position" and not fallen then
			-- This should probably not be hard coded like this
			if value.y < -50 then
				fallen=true
				print("Player fell: ", client.name)
				char.static = true
				wait(.1)
				engine.tween:begin(char, 1, {position = vector3(0,10,10), rotation=quaternion(0,0,0,1)}, "inOutQuad")
				wait(1.2)
				char.static = false
				fallen = false
			else
				local v = char.velocity
				v.y=0
				v = v:normal()
				--print(v)
			--	char.rotation = quaternion:setLookRotation(v)
			end
		end
	end)
	
	controller.characters[client] = { updating=false, character = char, keys = {false,false,false,false}, speed = controller.defaultSpeed }
end)

engine.networking.clients:clientDisconnected(function (client)	wait(1)
	if controller.characters[client] then
		controller.characters[client].character:destroy()
		controller.characters[client] = nil
	end
end)

controller.keyBinds = {
	vector3( 0,  0,  1), --w
	vector3( 0,  0, -1), --s
	vector3( 1,  0,  0), --a
	vector3(-1,  0,  0) -- d
}

engine.networking:bind( "characterSetInputStarted", function( client, direction, cameraDirection )
	if not controller.characters[client] then return end

	cameraDirection = quaternion:setEuler(0, cameraDirection:getEuler().y + math.rad(180), 0)

	if direction == 5 then
		controller.characters[client].character:applyImpulse(0,300,0)
		return nil
	elseif controller.characters[client].keys[direction] == nil then 
		return nil
	end

	controller.characters[client].keys[direction] = true
	if not controller.characters[client].updating then
		controller.characters[client].updating = true
		engine.graphics:frameDrawn(function()
			if not update(client, cameraDirection) then
				controller.characters[client].updating =false
				self:disconnect() -- no input from user.
			end
		end)
	end
end)

engine.networking:bind( "characterSetInputEnded", function( client, direction )
	if not controller.characters[client] then return end
	if controller.characters[client].keys[direction] == nil then return end
	controller.characters[client].keys[direction] = false
end)

return controller