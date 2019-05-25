--[[
    Copyright 2019 Teverse
    @File core/server/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.defaultSpeed = 50
controller.characters = {}

update = function(client)
	if not client or type(client) ~= "client" then return false end
	local totalForce = vector3()
	local moved = false
	for i, pressed in pairs(controller.characters[client].keys) do
		if pressed then
			moved=true
			totalForce = totalForce + controller.keyBinds[i]
		end
	end
	if moved then
		controller.characters[client].character:applyForce(totalForce * controller.characters[client].speed)
	end
	return moved
end

engine.networking.clients:clientConnected(function (client)
	wait(1)
	local char = engine.construct("block", workspace, {
		name = client.id,
		size = vector3(2,3,1),
		colour = colour(math.random(),math.random(),math.random()),
		position = vector3(0,20,0),
		static = false,
		velocity = vector3(0,10,0)
	})
	engine.networking:toClient(client, "characterSpawned")
	print("spawned", client.name, "character")
	char:changed(function(property, value)
		if property == "position" then
			-- This should probably not be hard coded like this
			if value.y < -50 then
				print("Player fells", client.name)
				char.static = true
				engine.tween:begin(char, 1, {position = vector3(0,10,10), rotation=quaternion()}, "inOutQuad")
				wait(1.1)
				char.static = false
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
	vector3(0,0,1), --w
	vector3(0,0,-1), --s
	vector3(1,0,0), --a
	vector3(-1,0,0)
}

engine.networking:bind( "characterSetInputStarted", function( client, direction )
	if not controller.characters[client] then return end

	if controller.characters[client].keys[direction] == nil then 
		return nil
	end

	controller.characters[client].keys[direction] = true
	print(client.name, "key down", direction)

	if not controller.characters[client].updating then
		print("Input loop begin", client.name)
		controller.characters[client].updating = true
	engine.graphics:frameDrawn(function()
		if not update(client) then
			controllers.characters[client].updating =false
			print("Input loop ended", client.name)
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