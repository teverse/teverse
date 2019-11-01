local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local window = ui.window(shared.workshop.interface,
   "Settings",
   guiCoord(0, 620, 0, 500), --size
   guiCoord(0.5, -310, 0.5, -250), --pos
   false, --dockable
   true -- hidable
)

local sideBar = ui.create("guiFrame", window.content, {
   size = guiCoord(0.35, 3, 1, 6),
   position = guiCoord(0, -3, 0, -3)
}, "primaryVariant")

local tabs = {}

local function addTab(tabName, tabFrame)
	local tabBtn = ui.create("guiFrame", sideBar, {
		size = guiCoord(1, -30, 0, 30),
		position = guiCoord(0, 15, 0, 15 + (#tabs * 40)),
		borderRadius = 3,
		hoverCursor = "fa:s-hand-pointer"
	}, "primary")

	ui.create("guiTextBox", tabBtn, {
		size = guiCoord(1, -12, 1, -6),
		position = guiCoord(0, 6, 0, 3),
		text = tabName,
		handleEvents = false,
		align = enums.align.middleLeft
	}, "primaryText")

	if #tabs > 0 then
		tabFrame.visible = false
		tabBtn.backgroundAlpha = 0
	end

	tabBtn:mouseLeftPressed(function ()
		for _,v in pairs(tabs) do
			v[1].visible = false
			v[2].backgroundAlpha = 0
		end
		tabFrame.visible = true
		tabBtn.backgroundAlpha = 1
	end)

	table.insert(tabs, {tabFrame, tabBtn})
end

--local generalPage = ui.create("guiFrame", window.content, {
--   size = guiCoord(0.65, 0, 1, 0),
--   position = guiCoord(0.35, 0, 0, 0)
--}, "background")

--addTab("General", generalPage)

local themePage = ui.create("guiScrollView", window.content, {
   size = guiCoord(0.65, 0, 1, 0),
   position = guiCoord(0.35, 0, 0, 0)
}, "background")

require("tevgit:workshop/controllers/ui/components/themePreviewer.lua").parent = themePage

addTab("Theme", themePage)

if shared.developerMode then
	local developmentPage = ui.create("guiScrollView", window.content, {
	size = guiCoord(0.65, 0, 1, 0),
	position = guiCoord(0.35, 0, 0, 0)
	}, "background")

	ui.create("guiTextBox", developmentPage, {
		position = guiCoord(0, 15, 0, 15),
		size = guiCoord(1, -30, 0, 20),
		text = "This tab is mainly for developers of the workshop."
	}, "backgroundText")


	local createReload = ui.button(developmentPage, "Reload Workshop", guiCoord(0, 190, 0, 30), guiCoord(0, 15, 0, 50))
	createReload:mouseLeftPressed(function ()
		shared.workshop:reloadCreate()
	end)

	local shaderReload = ui.button(developmentPage, "Reload Shaders", guiCoord(0, 190, 0, 30), guiCoord(0, 15, 0, 90), "secondary")
	shaderReload:mouseLeftPressed(function ()
		shared.workshop:reloadShaders()
	end)

	local physicsDebugEnabled = false
	local physicsAABBs = ui.button(developmentPage, "Enable Physics AABBs", guiCoord(0, 190, 0, 30), guiCoord(0, 15, 0, 130), "secondary")
	physicsAABBs:mouseLeftPressed(function ()
		physicsDebugEnabled = not physicsDebugEnabled
		shared.workshop:setPhysicsDebug(physicsDebugEnabled)
		physicsAABBs.label.text = physicsDebugEnabled and "Disable Physics AABBs" or "Enable Physics AABBs"
	end)

	local runScriptBtn = ui.button(developmentPage, "Run Lua", guiCoord(0, 190, 0, 30), guiCoord(0, 15, 0, 170), "secondary")

	runScriptBtn:mouseLeftPressed(function ()
		shared.windows.runLua.visible = not shared.windows.runLua.visible
	end)

	local printDump = ui.button(developmentPage, "Print Dump", guiCoord(0, 190, 0, 30), guiCoord(0, 15, 0, 210), "secondary")
	printDump:mouseLeftPressed(function()
		local dump = shared.workshop:apiDump()
		print(engine.json:encode(dump))
	end)

  	addTab("Development", developmentPage)

  --local dump = globalWorkshop:apiDump()
	--print(globalEngine.json:encode(dump))
end

return window
