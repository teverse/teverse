-- Copyright (c) 2019 teverse.com
-- console.lua
-- Author(s) joritochip, TheCakeChicken

local consoleController = {}
local consoleCommands = require("tevgit:create/console/commands.lua")

local themeController = require("tevgit:create/controllers/theme.lua")
local uiController = require("tevgit:create/controllers/ui.lua")

consoleController.outputLines = {}

consoleController.commands = {}

function stringSplit(inputStr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputStr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function stringCount(inputStr, pat)
	if inputStr == nil or pat == nil then return end 
	return select(2, string.gsub(inputStr, pat, ""))
end

consoleController.createConsole = function()
	local windowObject = uiController.create("guiFrame", engine.workshop.interface, {
		name = "outputConsole",
		visible = false,
		draggable = true,
		size = guiCoord(0.5, 0, 0.5, 0),
		position = guiCoord(0.25, 0, 0.25, 0)
	})

	consoleController.consoleObject = windowObject

	local topbar = uiController.create("guiFrame", windowObject, {
		size = guiCoord(1, 0, 0, 25),
		name = "topbar"
	}, "primary")

	local titleText = uiController.create("guiTextBox", topbar, {
		size = guiCoord(0.2, 0, 1, -10),
		position = guiCoord(0, 10, 0, 5),
		text = "Console",
		fontSize = 20,
		readOnly = true,
		name = "windowTitle"
	}, "primary")

	local closeButton = uiController.create("guiTextBox", topbar, {
		backgroundColour  = colour:fromRGB(255, 0, 0),
		text = "X",
		size = guiCoord(0, 25, 0, 25),
		align = enums.align.middle,
		position = guiCoord(1, -25, 0, 0),
		name = "closeButton",
		readOnly = true
	}, "primary")

	local scrollView = uiController.create("guiScrollView", windowObject, {
		size = guiCoord(1, 0, 1, -50),
		position = guiCoord(0, 0, 0, 25),
		canvasSize = guiCoord(1, 0, 0, 0)
	})

	local entryLabel = uiController.create("guiTextBox", scrollView, {
		size = guiCoord(1, -10, 0, 50),
		position = guiCoord(0, 0, 0, 0),
		name = "entryLabel",
		wrap = true,
		multiline = true,
		readOnly = true,
		align = enums.align.topLeft,
		fontSize = 20,
		textColour = colour(1, 1, 1)
	}, "default")

	local cmdInput = uiController.create("guiFrame", windowObject, {
		size = guiCoord(1, 0, 0, 25),
		position = guiCoord(0, 0, 1, -25),
		name = "cmdInput"
	}, "secondary")

	local cmdDecorText = uiController.create("guiTextBox", cmdInput, {
		size = guiCoord(0, 20, 1, 0),
		position = guiCoord(0, 5, 0, 0),
		readOnly = true,
		multiline = false,
		text = ">",
		align = enums.align.middle,
		fontSize = 20,
		textColour = colour(1, 1, 1),
		name = "cmdDecorText"
	}, "secondary")

	local cmdInputText = uiController.create("guiTextBox", cmdInput, {
		size = guiCoord(1, -30, 1, 0),
		position = guiCoord(0, 25, 0, 0),
		multiline = false,
		text = "Type a command",
		align = enums.align.middleLeft,
		fontSize = 20,
		textColour = colour(1, 1, 1),
		name = "cmdInputText"
	}, "secondary")

	closeButton:mouseLeftPressed(function() 
		consoleController.consoleObject.visible = false
	end)

	local cmdBarActive = false 

	local commandHistoryIndex = 0
	local commandHistory = {}

	cmdInputText:keyFocused(function() 
		cmdBarActive = true
		if cmdInputText.text == "Type a command" then cmdInputText.text = "" end
	end)

	cmdInputText:keyUnfocused(function()
		cmdBarActive = false
	end)

	engine.input:keyPressed(function(inputObj)
		if inputObj.key == enums.key.f12 then
			if inputObj.systemHandled then return end
			consoleController.consoleObject.visible = not consoleController.consoleObject.visible
		elseif cmdBarActive == true then 
			if inputObj.key == enums.key["return"] then
				if cmdInputText.text ~= "Type a command" and cmdInputText.text ~= "" then
					table.insert(commandHistory, cmdInputText.text)
					commandHistoryIndex = #commandHistory + 1
					
					print("> "..cmdInputText.text)
					local args = stringSplit(cmdInputText.text, " ")
					local cmd = args[1]
					table.remove(args, 1)
					
					for key, command in next, consoleController.commands do
						for _, alias in next, command.commands do 
							if string.lower(cmd) == string.lower(alias) then
								local newArgs = {}
								for index, arg in next, args do
									if #command.arguments == index then
										local concat = arg
										for i, toConcat in next, args do
											if i > #command.arguments then concat = concat .. " " .. toConcat end
										end
										table.insert(newArgs, concat)
									else
										table.remove(args, index)
										table.insert(newArgs, arg)
									end
								end
								command.execute(newArgs)
							end
						end
					end
					
					cmdInputText.text = ""
				end
			elseif inputObj.key == enums.key.up and #commandHistory > 0 then 
				if commandHistoryIndex - 1 > 0 then 
					commandHistoryIndex = commandHistoryIndex - 1
					cmdInputText.text = commandHistory[commandHistoryIndex]
				end
			elseif inputObj.key == enums.key.down and #commandHistory > 0 then
				if commandHistoryIndex < #commandHistory + 1 then 
					commandHistoryIndex = commandHistoryIndex + 1
					if commandHistoryIndex > #commandHistory then 
						cmdInputText.text = "" 
					else
						cmdInputText.text = commandHistory[commandHistoryIndex]
					end
				end
			end
		end
	end)

	engine.debug:output(function(msg, type)
		if #consoleController.outputLines > 100 then
			table.remove(consoleController.outputLines, 1)
		end
		table.insert(consoleController.outputLines, {msg, type})
		
		local text = ""

		for _,v in pairs (consoleController.outputLines) do
			local colour = (v[2] == 1) and "#ff0000" or "#ffffff"
			if text ~= "" then
				text = string.format("%s\n%s%s", text, colour, v[1])
			else
				text = string.format("%s%s", colour, v[1])
			end
		end

		-- deprecated but it's the only way to do color afaik
		entryLabel:setText(text)
		
		local size = stringCount(text, "\n")*20+20
		
		entryLabel.size = guiCoord(1, -10, 0, size)
		scrollView.canvasSize = guiCoord(0, 0, 0, size)
	end)
end

consoleController.commands = consoleCommands.getCommands(consoleController)
return consoleController
