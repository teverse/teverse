--[[
    Copyright 2019 Teverse
    @File core/client/chat.lua
    @Author(s) Jay
--]]

local container = engine.construct("guiFrame", engine.interface, {
	size			 = guiCoord(0,350,0,600),
	position		 = guiCoord(0, 0, 1, -655),
	backgroundColour = colour(0.1, 0.1, 0.1),
	handleEvents	 = false,
	backgroundAlpha  = 0.1,
	zIndex			 = 1001
})

local messagesOutput = engine.construct("guiTextBox", container, {
	size			= guiCoord(1, -8, 1, -34),
	position		= guiCoord(0, 4, 0, 2),
	backgroundAlpha = 0,
	handleEvents	= false,
	align 			= enums.align.bottomLeft,
	fontSize 		= 21,
	text			= ""
})

local messageInputFrame = engine.construct("guiFrame", container, {
	size			 = guiCoord(0, 350, 0, 25),
	position		 = guiCoord(0, 30, 1, -30),
	backgroundColour = colour(0.1, 0.1, 0.1),
	handleEvents	 = false,
	backgroundAlpha  = 0.8,
	zIndex			 = 1001
})

local messageInputBox = engine.construct("guiTextBox", messageInputFrame, {
	size			= guiCoord(1, -8, 1, -4),
	position		= guiCoord(0, 4, 0, 2),
	backgroundAlpha = 0,
	align 			= enums.align.middleLeft,
	fontSize 		= 21,
	text			= "Type here",
	readOnly		= false,
	multiline		= false,
	zIndex			= 1001
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
	messagesOutput.text = newValue
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