--[[
    Copyright 2019 Teverse
    @File core/client/playerList.lua
    @Author(s) Jay
--]]
print("player list")
local container = engine.construct("guiFrame", engine.interface, {
	size=guiCoord(0,350,0,300),
	position=guiCoord(0, 30, 1, -665),
	backgroundColour=colour(0.1,0.1,0.1),
	handleEvents=false,
	visible = false,
	alpha = 0.1,
	zIndex=1001
})

engine.networking:connected(function (serverId)
	container.visible=true
end)

local function positionPlayers()
	local y = 5
	for _,v in pairs(container.children) do
		v.position = guiCoord(0,5,0,y)
		y = y + 21
	end
end

engine.networking.clients:clientConnected(function (client)
	local playerGui = engine.construct("guiTextBox", container, {
		name = client.name,
		size = guiCoord(1, -10, 0, 16),
		text = client.name,
		backgroundColour=colour(0.1,0.1,0.1)
	})

	positionPlayers()
end)

engine.networking.clients:clientDisconnected(function (client)
	if container:hasChild(client.name) then
		container[client.name]:destroy()
	end
end)