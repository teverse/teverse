local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local window = ui.window(shared.workshop.interface,
   "Run Lua",
   guiCoord(0, 420, 0, 70), --size
   guiCoord(0.5, -210, 0.5, -25), --pos
   false, --dockable
   true -- hidable
)

local runScriptBtn = ui.button(window.content, "Run", guiCoord(0, 50, 0, 30), guiCoord(0, 5, 0, 7), "primary")

local runScriptInput = ui.create("guiTextBox", window.content, {
	size = guiCoord(1, -65, 0, 30),
	position = guiCoord(0, 65, 0, 7),
	readOnly = false,
	wrap = true,
	fontSize = 16
}, "secondary")

runScriptBtn:mouseLeftPressed(function ()
	shared.workshop:loadString(runScriptInput.text)
	runScriptInput.text = ""
end)

return window
