local container = engine.construct("guiFrame", engine.interface, {
	size			 = guiCoord(0,400,0,295),
	position		 = guiCoord(0, 350, 1, -295),
	backgroundColour = colour(0.1, 0.1, 0.1),
	handleEvents	 = false,
	backgroundAlpha  = 0.1,
	zIndex			 = 1001
})

local serverOutput = engine.construct("guiTextBox", container, {
	size			= guiCoord(1, -8, 1, -45),
	position		= guiCoord(0, 4, 0, 2),
	backgroundAlpha = 0,
	handleEvents	= false,
	align 			= enums.align.bottomLeft,
	fontSize 		= 15,
	text			= "[Server Output]"
})

local logs = {}
local function updateOutput()
	if #logs > 40 then
		table.remove(logs, 1)
	end
	local t = ""
	for _,v in pairs(logs) do
		t = t .. "[" .. os.date("%X", v[1]) .. "] " .. v[2] .. "\n"
	end
	serverOutput.text = t .. "\n[Server Output]"
end

engine.networking:bind( "serverOutput", function( serverTime, msg, type )
	print("server output")
	table.insert(logs, {serverTime, msg})
	updateOutput()
end)