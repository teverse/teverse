-- Copyright 2020- Teverse
-- This script is responsible for parsing and storing commands

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files

--[[
    TEST DOCUMENT

    -- How to register a plugin

    local commands = require("...")
    local extension = commands.createGroup("Hello")
    extension.command("ping", function() print("pong") end)
    -- >hello: ping
    ---> pong!
]]

return {
    createGroup = function(id)
        local data = {}
        self = data
        self.id = id
        self.commands = {}
        table.insert(globals.commandGroups, id)

        self.command = function(id, callback)
            table.insert(commands, {id=callback})
        end

        self.invokeCommand = function(id)
            for i,v in pairs(self.commands) do
                for k,l in pairs(self.commands[i]) do
                    if l == id then return print("FOUND: "..id) end
                end
            end 
        end

        return data 
    end,

    parse = function(text)
         -- Sytax
         ---> group: name
         local commandIndex = string.find(text, ":")
         if commandIndex == -1 then print("Failed to find command group: "..text) return end
         local commandGroup = string.sub(text, 0, (commandIndex-1))
         print("commandGroup: "..commandGroup)


         --[[for i,v in pairs(globals.commandGroups) do
            for k,l in pairs(self.commands[i]) do
                if l == 
            end
         end]]--
    end
}