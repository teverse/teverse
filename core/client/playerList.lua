--[[
    Copyright 2020 Teverse
    @File core/client/playerList.lua
    @Author(s) Jay
--]]

-- tab

local container = engine.construct("guiFrame", engine.interface, {
	name 			 = "playerList",
	size			 = guiCoord(0,355,0,205),
	position		 = guiCoord(1, -350, 0, -5),
	backgroundColour = colour(0.1, 0.1, 0.1),
	handleEvents	 = false,
	backgroundAlpha  = 0,
	borderRadius 	 = 5,
	zIndex			 = 1001
})

local function positionPlayers()
	local y = 5
	for _,v in pairs(container.children) do
		v.position = guiCoord(0,5,0,y)
		y = y + 21
	end
end

local function addPlayer(client)
	local playerGui = engine.construct("guiFrame", container, {
		name 			 = client.name,
		size 			 = guiCoord(1, -5, 0, 22),
		backgroundColour = colour(0.1, 0.1, 0.1),
		backgroundAlpha  = 0.1
	})
	
	local label = engine.construct("guiTextBox", playerGui, {
		name 			= "label",
		size 			= guiCoord(1, -30, 1, 0),
		position    	= guiCoord(0, 30, 0, 0),
		align 			= enums.align.middleLeft,
		fontSize    	= 18,
		text 			= client.name,
		backgroundAlpha = 0
	})

	positionPlayers()
end

for _,client in pairs(engine.networking.clients.children) do
	addPlayer(client)
end

engine.networking.clients:clientConnected(addPlayer)

engine.networking.clients:onSync("clientDisconnected", function (client)
	if container:hasChild(client.name) then
		container[client.name]:destroy()
		container[client.name] = nil
		positionPlayers()
	end
end)