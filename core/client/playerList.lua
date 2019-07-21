--[[
    Copyright 2019 Teverse
    @File core/client/playerList.lua
    @Author(s) Jay
--]]
local container = engine.construct("guiFrame", engine.interface, {
	size=guiCoord(0,350,0,200),
	position=guiCoord(0, 30, 0, 30),
	backgroundColour=colour(0.1,0.1,0.1),
	handleEvents=false,
	backgroundAlpha = 0.5,
	zIndex=1001
})

local function positionPlayers()
	local y = 5
	for _,v in pairs(container.children) do
		v.position = guiCoord(0,5,0,y)
		y = y + 21
	end
end

local function addPlayer(client)
	local playerGui = engine.construct("guiTextBox", container, {
		name = client.name,
		size = guiCoord(1, -10, 0, 16),
		fontSize = 16,
		text = client.name,
		readOnly=true,
		backgroundColour=colour(0.1,0.1,0.1),
		zIndex=1002
	})

	positionPlayers()
end

for _,client in pairs(engine.networking.clients.children) do
	addPlayer(client)
end

engine.networking.clients:clientConnected(addPlayer)

engine.networking.clients:clientDisconnected(function (client)
	if container:hasChild(client.name) then
		container[client.name]:destroy()
		positionPlayers()
	end
end)