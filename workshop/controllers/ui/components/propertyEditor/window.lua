local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local controller = {}

local modulePrefix = "tevgit:workshop/controllers/ui/components/propertyEditor/"

controller.window = ui.window(shared.workshop.interface, "Properties",
    guiCoord(0, 260, 0, 400), -- size
	guiCoord(1, -260, 0.5, -25), -- pos
	true, -- dockable
	true -- hidable
)

info = ui.create("guiTextBox", controller.window.content, {
    size = guiCoord(1, 0, 0, 18),
    text = "Nothing selected",
    fontSize = 18
}, "backgroundText")

controller.scrollView = ui.create("guiScrollView", controller.window.content, {
    size = guiCoord(1, 0, 1, -18),
    position = guiCoord(0, 0, 0, 18),
    backgroundAlpha = 0
}, "primary")

controller.eventHandlers = {}

local parseUpdates = require(modulePrefix .. "parseUpdates.lua")
local parseInputs = require(modulePrefix .. "parseInputs.lua")
local createInputs = require(modulePrefix .. "createInputs.lua")

local selection = require("tevgit:workshop/controllers/core/selection.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

local function alphabeticalSorter(a, b) return a.property < b.property end

local excludePropertyList = {
    physics = true, -- letting user changes this will break raycasts
    doNotSerialise = true
}

function controller.generateProperties()
    for i, v in pairs(controller.eventHandlers) do v:disconnect() end

    controller.eventHandlers = {}
    if #selection.selection > 0 then
        local firstObject = selection.selection[1]
        local members = shared.workshop:getMembersOfObject(firstObject)

        table.sort(members, alphabeticalSorter)

        controller.scrollView:destroyAllChildren()

        local y = 10
        local propertiesCount = 0

        for i, v in pairs(members) do
            local value = firstObject[v.property]
            local pType = type(value)
            local readOnly = not v.writable

            if not readOnly and pType ~= "function" and
                not excludePropertyList[v.property] then
                propertiesCount = propertiesCount + 1

                local container = engine.construct("guiFrame",
                                                   controller.scrollView, {
                    backgroundAlpha = 0,
                    size = guiCoord(1, -10, 0, 20),
                    position = guiCoord(0, 0, 0, y),
                    cropChildren = false
                })

                local label = ui.create("guiTextBox", container, {
                    name = "label",
                    size = guiCoord(0.6, -15, 1, 0),
                    position = guiCoord(0, 0, 0, 0),
                    fontSize = 18,
                    text = v.property,
                    align = enums.align.topRight
                }, "backgroundText")

                local inputGui = nil

                if createInputs[pType] then
                    inputGui = createInputs[pType](firstObject, v.property,
                                                   value)
                else
                    inputGui = createInputs.default(firstObject, v.property,
                                                    value)
                end

                container.size = guiCoord(1, -10, 0, inputGui.size.offsetY)
                container.zIndex = inputGui.zIndex
                inputGui.parent = container

                if parseInputs[pType] then
                    parseInputs[pType](firstObject, container.inputContainer,
                                       value)
                end

                container.position = guiCoord(0, 5, 0, y)

                y = y + container.size.offsetY + 3
            end
        end

        info.text = type(firstObject) .. " has " .. tostring(propertiesCount) ..
                        " visible members."

        table.insert(controller.eventHandlers,
			firstObject:changed(
				function(prop, val)
				if parseInputs[type(val)] then
					local container = controller.scrollView["_" .. prop]
					if container then
						parseInputs[type(val)](firstObject, container.inputContainer, val)
					end
				end
			end)
		)

        local newSize = guiCoord(0, 0, 0, y)

        if newSize ~= controller.scrollView.canvasSize then
            controller.scrollView.viewOffset = vector2(0, 0)
        end

        controller.scrollView.canvasSize = newSize
    else
        info.text = "Nothing selected."
    end
end

selection.registerCallback(controller.generateProperties)

return controller
