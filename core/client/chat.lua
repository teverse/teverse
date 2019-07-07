--[[
    Copyright 2019 Teverse
    @File core/client/chat.lua
    @Author(s) Jay
--]]

local container = engine.construct("guiFrame", engine.interface, {
	size=guiCoord(0,350,0,300),
	position=guiCoord(0, 30, 1, -355),
	backgroundColour=colour(0.1,0.1,0.1),
	handleEvents=false,
	alpha = 0.1,
	zIndex=1001
})


local messagesTextBox = engine.construct("guiTextBox",container, {
	size=guiCoord(1, -8, 1, -4),
	position=guiCoord(0,4,0,2),
	guiStyle = enums.guiStyle.noBackground,
	handleEvents=false,
	align = enums.align.bottomLeft,
	fontSize = 21,
	text="",
	fontFile = "OpenSans-Regular.ttf",
	zIndex=1001
})


local messageInputFrame = engine.construct("guiFrame", engine.interface, {
	size=guiCoord(0,350,0,25),
	position=guiCoord(0, 30, 1, -55),
	backgroundColour=colour(0.1,0.1,0.1),
	handleEvents=false,
	alpha = 0.8,
	zIndex=1001
})

local messageInputBox = engine.construct("guiTextBox",messageInputFrame, {
	size=guiCoord(1, -8, 1, -4),
	position=guiCoord(0,4,0,2),
	guiStyle = enums.guiStyle.noBackground,
	align = enums.align.middleLeft,
	fontSize = 21,
	text="type here, and enter!",
	readOnly=false,
	multiline=false,
	fontFile = "OpenSans-Regular.ttf",
	zIndex=1001
})

messageInputBox:keyPressed(function(inputObj)
	if inputObj.key == enums.key['return'] then
		engine.networking:toServer("message", messageInputBox.text)
		messageInputBox.text = ""
	end
end)

function addMessage(txt)
	local newValue = messagesTextBox.text .. "\n" .. txt
	if (newValue:len() > 610) then
		newValue = newValue:sub(newValue:len() - 600)
	end
	messagesTextBox.text = newValue
end

engine.networking:bind( "message", function( from, message )
	addMessage(from .. " : " .. message)
end)

engine.networking.clients:clientConnected(function (client)
	addMessage(client.name .. " has joined.")
end)

engine.networking.clients:clientDisconnected(function (client)
	addMessage(client.name .. " has disconnected.")
end)

engine.networking:disconnected(function (serverId)
	addMessage("You have disconnected.")
end)