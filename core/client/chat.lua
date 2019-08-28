--[[
    Copyright 2019 Teverse
    @File core/client/chat.lua
    @Author(s) Jay
--]]

-- Used to add a background to the version/user info on bottom left of Teverse.
local bottomLeftInfoBG = engine.construct("guiFrame", engine.interface, {
	name = "InfoBG",
	size = guiCoord(0, 350, 0, 45),
	position = guiCoord(0, 0, 1, -45),
	backgroundColour = colour:black(),
	backgroundAlpha = 0.4
})

local container = engine.construct("guiFrame", engine.interface, {
	size			 = guiCoord(0,350,0,250),
	position		 = guiCoord(0, 0, 1, -295),
	backgroundColour = colour(0.1, 0.1, 0.1),
	handleEvents	 = false,
	backgroundAlpha  = 0.1,
	zIndex			 = 1001
})

local messagesOutput = engine.construct("guiTextBox", container, {
	size			= guiCoord(1, -8, 1, -45),
	position		= guiCoord(0, 4, 0, 2),
	backgroundAlpha = 0,
	handleEvents	= false,
	align 			= enums.align.bottomLeft,
	fontSize 		= 21,
	text			= ""
})

local messageInputFrame = engine.construct("guiFrame", container, {
	size			 = guiCoord(1, -30, 0, 24),
	position		 = guiCoord(0, 15, 1, -39),
	backgroundColour = colour(0.1, 0.1, 0.1),
	fontSize         = 18,
	handleEvents	 = false,
	backgroundAlpha  = 0.4,
	borderRadius	 = 2,
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

messageInputBox:keyFocused(function ()
	if messageInputBox.text == "Type here" then
		messageInputBox.text = ""
	end
end)

messageInputBox:keyPressed(function(inputObj)
	if inputObj.key == enums.key['return'] then
		engine.networking:toServer("message", messageInputBox.text)
		messageInputBox.text = ""
	end
end)

function addMessage(txt)
	local newValue = messagesOutput.text .. "\n" .. txt
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