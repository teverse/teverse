-- Copyright 2020- Teverse
-- This script constructs (or builds) the default in-game chat system on the server

teverse.networking:on("ChatMessage", function(client, message)
    teverse.networking:broadcast("ChatMessage", client, message)
end)

--[[
teverse.networking:on("_clientConnected", function(client)
    teverse.networking:broadcast("ChatClientAdd", "Server", client.name .. " joined the chat")
end)

teverse.networking:on("_clientDisconnected", function(client)
    teverse.networking:broadcast("ChatClientRemoved", "Server", client.name .. " left the chat")
end)
]]--