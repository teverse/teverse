--[[
    Copyright 2019 Teverse
    @File core/server/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

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
			controller.character:applyForce(totalForce * 50)
		end

		return moved
	end

engine.networking.clients:clientConnected(function (client)
	wait(1)
	local char = engine.construct("block", workspace, {
		name = client.id,
		size = vector3(2,3,1),
		colour = colour(math.random(),math.random(),math.random()),
		position = vector3(0,10,0),
		static = false,
		velocity = vector3(0,10,0)
	})
	engine.networking:toClient(client, "characterSpawned")
	controller.characters[client] = { character = char, keys = {false,false,false,false} }
end)

controller.keyBinds = {
	vector3(0,0,1), --w
	vector3(0,0,-1), --s
	vector3(1,0,0), --a
	vector3(-1,0,0) --d
}

engine.networking:bind( "characterSetInputStarted", function( client, direction )
	if not controller.characters[client] then return end
	if controller.characters[client].keys[direction] == nil then return end

	controller.characters[client].keys[direction] = true
	engine.graphics:frameDrawn(function()
		if not update(client) then
			self:disconnect() -- no input from user.
		end
	end)
end)

engine.networking:bind( "characterSetInputEnded", function( client, direction )
	if not controller.characters[client] then return end
	if controller.characters[client].keys[direction] == nil then return end

	controller.characters[client].keys[direction] = false
end)

return controller