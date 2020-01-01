--[[
    Copyright 2020 Teverse
    @File core/server/chat.lua
    @Author(s) Jay
--]]

engine.networking:bind( "message", function( client, message )
	if type(message) == "string" then
		print(client.name, "said", message)
		engine.networking:toAllClients("message", client.name, message)
	end
end)