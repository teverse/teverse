-- very messy
-- i dont know why i did some of this like this


local lexer = require("tevgit:create/scriptEditor/lexer.lua")
local scriptEditor = {}
scriptEditor.mainFrame = engine.construct("guiFrame", engine.interface, {
					size=guiCoord(0.5, -30, 0.5, 0),
					position=guiCoord(0.25, 30, 0.25, 0),
					backgroundColour=colour:fromRGB(40, 42, 54),
					handleEvents=false,
					zIndex=1002
})

scriptEditor.mainText = engine.construct("guiTextBox", scriptEditor.mainFrame, {
	size=guiCoord(1,-10,1,-10),
	position=guiCoord(0,5,0,5),
	zIndex=1002,
	align=enums.align.topLeft,
	fontFile = "FiraMono-Regular.ttf",
	fontSize=18,
	multiline=true,
	readOnly=false,
	wrapped = true,
	textAlpha=0.2,
	text = [[print("Hello Teverse!")]],
	backgroundAlpha = 0
})
scriptEditor.colours = {
	background = colour:fromRGB(40, 42, 54),
	currentLine = colour:fromRGB(68, 71, 90),
	selection = colour:fromRGB(68, 71, 90),
	foreground = colour:fromRGB(248, 248, 242),
	
	comment=colour:fromRGB(30,30,70), 
	string_start=colour:fromRGB(241,250,140), --YELLOW
	string_end=colour:fromRGB(241,250,140),--yellow
	string=colour:fromRGB(241,250,140),--yellow
	escape=colour:fromRGB(189,147,249),--purple
	keyword=colour:fromRGB(255,121,198),--cyan
	value=colour:fromRGB(189,147,249), 
	ident=colour:fromRGB(80,250,123),
	number=colour:fromRGB(189,147,249),
	symbol=colour:fromRGB(255,121,198), --PINK
	vararg=colour:fromRGB(255,184,108),
	operator=colour:fromRGB(255,121,198),
	label_start=colour:fromRGB(255, 184, 108),
	label_end=colour:fromRGB(255, 184, 108),
	label=colour:fromRGB(255, 184, 108),
	unidentified=colour(1,0,0)
}

scriptEditor.lex = function()
	--scriptEditor.colouredText:setTextColour(scriptEditor.colours["default"])

	--local curC = 0
	local text = scriptEditor.mainText.text
	scriptEditor.mainText.textColour = colour(0.5, 0.5, 0.5)
	--scriptEditor.colouredText.text = text
	--wait()
	--print(engine.lexer.lex, type(engine.lexer.lex))
	local lexxed = lexer.lex(text)
	local lineStart =0
	local lineText = ""

	print(text:len())
	--print(lexxed, type(lexxed))
	for i, line in pairs(lexxed) do
		local thisLine = 0
		for t,v in pairs(line) do
			v.posFirst = v.posFirst -1

			scriptEditor.mainText:setTextColour(lineStart + v.posFirst, lineStart + v.posLast, scriptEditor.colours[v.type] and scriptEditor.colours[v.type] or colour(0.5,0.5,0.5))
			print("'"..v.data.."'", lineStart + v.posFirst, lineStart + v.posLast, scriptEditor.colours[v.type] and scriptEditor.colours[v.type] or colour(0.5,0.5,0.5))
		--	curC = curC + len
			thisLine = v.posLast
		end
		lineStart = lineStart + thisLine + 1
		lineText = lineText .. (i-1) .."\n" 
	end
	lineText = lineText .. "-"
	scriptEditor.leftText.text = lineText
end

scriptEditor.lastType = nil
scriptEditor.lastText = ""
scriptEditor.mainText:textInput(function (txt)
	scriptEditor.lastText = txt
	if scriptEditor.lastType == nil then
		spawnThread(function ()
			-- Code here...
		repeat wait() until (os.clock() - scriptEditor.lastType) > 0.05
			local text = scriptEditor.mainText.text

		wait()

			scriptEditor.lex()
			scriptEditor.lastType = nil
		end)
	end

	scriptEditor.lastType = os.clock()
end)

scriptEditor.leftFrame = engine.construct("guiFrame", engine.interface, {
					size=guiCoord(0, 30, 0.5, 0),
					position=guiCoord(0.25, 0, 0.25, 0),
					backgroundColour=scriptEditor.colours.background,
					handleEvents=false,
					zIndex=1002
})


scriptEditor.leftText = engine.construct("guiTextBox", scriptEditor.leftFrame, {
	size=guiCoord(1,-10,1,-10),
	position=guiCoord(0,5,0,5),
	zIndex=1002,
	align=enums.align.topLeft,
	fontFile = "FiraMono-Regular.ttf",
	fontSize=18,
	multiline=true,
	textColour=scriptEditor.colours.comment,
	text = [[0]],
	backgroundAlpha = 0
})

scriptEditor.lex()


return scriptEditor