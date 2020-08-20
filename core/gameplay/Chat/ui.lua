-- Copyright 2020- Teverse
-- This script constructs (or builds) the default in-game chat system on the client

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files

-- Load the networking debug UI from the teverse/teverse github
--local debugContainer = require("tevgit:utilities/networkDebug.lua")()
--debugContainer.parent = teverse.interface

local clientLocal = teverse.networking.localClient

return {
    ui = function()
        local chatContainer = teverse.construct("guiFrame", {
            parent = teverse.interface,
            size = guiCoord(0, 300, 0, 200),
            position = guiCoord(0, 0, 0, 0),
            backgroundColour = globals.defaultColours.white,
            backgroundAlpha = 0.3,
            clip = true,
            visible = false
        })

        local chatInputField = teverse.construct("guiTextBox", {
            parent = teverse.interface,
            size = guiCoord(1, 0, 0, 20),
            position = guiCoord(0, 0, 0.9, 0),
            textAlign = "middleLeft",
            textSize = 16,
            text = " Click to chat",
            textColour = globals.defaultColours.black,
            backgroundColour = globals.defaultColours.white,
            backgroundAlpha = 0.3,
            textEditable = true,
            textMultiline = false,
            visible = false
        })


        function chatShift()
            if #chatContainer.children == 0 then return end
            for _, message in pairs(chatContainer.children) do
                message.position = message.position + guiCoord(0, 0, 0, -15)
            end
        end


        function message(client, text)

            -- Should add a pcall here to determine if the message was sent successfully
            -- If not, display that the message was never sent
            teverse.networking:sendToServer("chat", text)

            local Message = teverse.construct("guiFrame", {
                parent = chatContainer,
                size = guiCoord(1, 0, 0, 15),
                position = guiCoord(0, 0, 0, 185),
                backgroundColour = globals.defaultColours.white,
                backgroundAlpha = 0
            })

            teverse.construct("guiTextBox", {
                parent = Message,
                size = guiCoord(1, 0, 1, 0),
                position = guiCoord(0, 0, 0, 0),
                textSize = 16,
                text = "["..client.name.."] "..text,
                backgroundColour = globals.defaultColours.white,
                backgroundAlpha = 0,
                textColour = globals.defaultColours.black,
                textAlign = enums.align.middleLeft
            })
        end


        function serverMessage(client, message, color)
            local joinMessage = teverse.construct("guiFrame", {
                parent = chatContainer,
                size = guiCoord(1, 0, 0, 15),
                position = guiCoord(0, 0, 0, 185),
                backgroundColour = globals.defaultColours.white,
                backgroundAlpha = 0
            })

            teverse.construct("guiTextBox", {
                parent = joinMessage,
                size = guiCoord(1, 0, 1, 0),
                position = guiCoord(0, 0, 0, 0),
                textSize = 16,
                text = "[SERVER] "..client.name..message,
                backgroundColour = globals.defaultColours.white,
                backgroundAlpha = 0,
                textColour = color,
                textAlign = enums.align.middleLeft
            })
        end

        function clientAddMessage(client, text)
            chatShift()
            message(client, text) 
        end

        -- On the fence about this, will reconsider. 
        --function clientRemoveMessage() end

        chatInputField:on("keyDown", function(key)
            if key == "KEY_RETURN" then
                chatContainer.visible = true
                clientAddMessage(clientLocal, chatInputField.text)
                chatInputField.text = " "
                sleep(10)
                chatContainer.visible = false
                chatInputField.visible = false
            end
        end)

        chatInputField:on("mouseLeftDown", function(position)
            chatInputField.text = " "
        end)

        teverse.input:on("keyDown", function(key)
            if key == "KEY_SLASH" then
                chatInputField.visible = true
            end
        end)

        -- Networking Events
        teverse.networking:on("ChatMessage", message)
        teverse.networking:on("_clientConnected", function(client) serverMessage(client, " has joined the server.", globals.defaultColours.green) end)
        teverse.networking:on("_clientDisconnected", function(client) serverMessage(client, " has left the server.", globals.defaultColours.red) end)
        teverse.networking:on("_disconnected", function(client) serverMessage(client, " has disconnected from the server.", globals.defaultColours.yellow) end)
        teverse.networking:on("_connected", function(client) serverMessage(client, " has connected to the server.", globals.defaultColours.yellow) end)
    end
}