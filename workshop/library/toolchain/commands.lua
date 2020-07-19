-- Copyright 2020- Teverse
-- This script is responsible for parsing and storing commands

local globals = require("tevgit:workshop/library/globals.lua") -- globals; variables or instances that can be shared between files

return {
    createGroup = function(id)
        local data = {}
        self = data
        self.id = id
        self.commands = {}
        globals.commandGroups[id] = {}

        self.command = function(id, callback)
            table.insert(globals.commandGroups[data.id], {[tostring(id)]=callback})
        end

        return data 
    end,

    parse = function(text)
        -- Sytax
        ---> group: name
        local commandIndex = string.find(text, ":")
        if commandIndex == -1 or commandIndex == nil then print("Failed to find command group: "..text) return end
        local commandGroup = string.gsub(string.sub(text, 0, (commandIndex-1)), "%s+", "")
        local commandName = string.gsub(string.sub(text, (commandIndex+1), string.len(text)), "%s+", "")

        for row, group in pairs(globals.commandGroups) do
            for column, placement in pairs(group) do
                for selection, trigger in pairs(placement) do
                    if(commandGroup == ">"..row) and (commandName == selection) then
                        placement[selection]()
                        print("COMMAND INVOKED")
                    end
                end
            end 
        end
    end
}