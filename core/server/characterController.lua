--[[
    Copyright 2019 Teverse
    @File core/server/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.characters = {}

engine.networking.clients:clientConnected(function (client)
	wait(1)
	local char = engine.construct("block", workspace, {
		name = client.id
		size = vector3(2,3,1),
		colour = colour(math.random(),math.random(),math.random()),
		position = vector3(0,10,0),
		static = false,
		velocity = vector3(0,10,0)
	})
	engine.networking:toClient(client, "characterSpawned")
end)

engine.networking:bind( "message", function( client, message )
	if type(message) == "string" then
		print(client.name, "said", message)
		engine.networking:toAllClients("message", client.name, message)
	end
end)

return controller