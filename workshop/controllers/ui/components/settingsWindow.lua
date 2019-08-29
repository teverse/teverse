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
		align = enums.align.middleLeft
	}, "primaryText")

	for _,v in pairs(tabs) do
		v.visible = false
	end

	if #tabs > 0 then
		tabFrame.visible = false
		tabBtn.backgroundAlpha = 0
	end

	tabBtn:mouseLeftPressed(function ()
		for _,v in pairs(tabs) do
			v.visible = false
		end
		tabFrame.visible = true
		tabBtn.backgroundAlpha = 1
	end)

	table.insert(tabs, tabFrame)
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