local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local window = ui.window(shared.workshop.interface, 
   "Settings", 
   guiCoord(0, 600, 0, 500), --size
   guiCoord(0.5, -300, 0.5, -250), --pos
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
		borderRadius = 3
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

local generalPage = ui.create("guiScrollView", window.content, {
   size = guiCoord(0.65, 0, 1, 0),
   position = guiCoord(0.35, 0, 0, 0)
}, "background")

addTab("General", generalPage)

local themePage = ui.create("guiScrollView", window.content, {
   size = guiCoord(0.65, 0, 1, 0),
   position = guiCoord(0.35, 0, 0, 0)
}, "background")

require("tevgit:workshop/controllers/ui/components/themePreviewer.lua").parent = themePage

addTab("Theme", themePage)

local developmentPage = ui.create("guiScrollView", window.content, {
   size = guiCoord(0.65, 0, 1, 0),
   position = guiCoord(0.35, 0, 0, 0)
}, "background")

ui.create("guiTextBox", developmentPage, {
	position = guiCoord(0, 15, 0, 15),
	size = guiCoord(1, -30, 0, 20),
	text = "This tab is mainly for developers of create mode."
}, "backgroundText")

local reloadBtn = ui.create("guiFrame", developmentPage, {
	size = guiCoord(0, 150, 0, 30),
	position = guiCoord(0, 15, 0, 50),
	borderRadius = 3
}, "primary")

reloadBtn:mouseLeftPressed(function ()
	shared.workshop:reloadCreate()
end)

ui.create("guiTextBox", reloadBtn, {
	size = guiCoord(1, -12, 1, -6),
	position = guiCoord(0, 6, 0, 3),
	text = "Reload Workshop",
	handleEvents = false,
	align = enums.align.middle
}, "primaryText")

local reloadShadersBtn = ui.create("guiFrame", developmentPage, {
	size = guiCoord(0, 150, 0, 30),
	position = guiCoord(0, 175, 0, 50),
	borderRadius = 3
}, "secondary")

reloadShadersBtn:mouseLeftPressed(function ()
	shared.workshop:reloadShaders()
end)

ui.create("guiTextBox", reloadShadersBtn, {
	size = guiCoord(1, -12, 1, -6),
	position = guiCoord(0, 6, 0, 3),
	text = "Reload Shaders",
	handleEvents = false,
	align = enums.align.middle
}, "secondaryText")



addTab("Development", developmentPage)
