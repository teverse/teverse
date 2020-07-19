local dragMove = require("tevgit:core/teverseUI/tabMove.lua")
local dragResize = require("tevgit:core/teverseUI/resize.lua")

local container = teverse.construct("guiFrame", {
	parent = teverse.coreInterface,
	size = guiCoord(0,
		math.max(teverse.coreInterface.absoluteSize.x / 3, 100),
		0,
		math.max(teverse.coreInterface.absoluteSize.y / 3, 200));
	position = guiCoord(0, 20, 0, 20);
	visible = false;
	strokeWidth = 2;
	strokeColour = colour(0.75,0.75,0.75);
	strokeAlpha = 1;
	strokeRadius = 2;
})

local topBar = teverse.construct("guiFrame", {
	parent = container;
	size = guiCoord(1, 0, 0, 20);
	backgroundColour = colour(0.75, 0.75, 0.75);
})

local title = teverse.construct("guiTextBox", {
	parent = topBar;
	size = guiCoord(1, -24, 1, 0);
	position = guiCoord(0, 4, 0, 0);
	backgroundAlpha = 0;
	active = false;
	textSize = 20;
	text = "Console"
})

local leave = teverse.construct("guiFrame", {
	parent = topBar;
	size = guiCoord(0, 10, 0, 10);
	position = guiCoord(1, -15, 0, 5);
	backgroundColour = colour(0.70, 0.35, 0.35);
	strokeRadius = 10
})

local commandLine = require("tevgit:core/teverseUI/commandLine.lua")
commandLine.parent = container
commandLine.size = guiCoord(1, 0, 0, 20)
commandLine.position = guiCoord(0, 0, 1, -20)

local log = require("tevgit:core/teverseUI/log.lua")({
	parent = container;
	size = guiCoord(1, 0, 1, -40);
	position = guiCoord(0, 0, 0, 20);
	scrollbarRadius = 0.01;
	scrollbarWidth = 4;
	scrollbarColour = colour(.8,.8,.8);
})

dragResize(container)

dragMove(topBar, container)

leave:on("mouseLeftDown", function()
	container.visible = false
end)

teverse.debug:on("print", function(printOut)
	log.add(os.date("%H:%M:%S", os.time()) .. ": " .. printOut:gsub("\t", ""))
end)

container:on("changed", log.reload)

for _,v in pairs(teverse.debug:getOutputHistory()) do
	log.add(os.date("%H:%M:%S", v.time).. ": " .. v.message:gsub("\t", ""))
end

return container