local controller = {}

local shared = require("tevgit:workshop/controllers/shared.lua")
local selection = require("tevgit:workshop/controllers/core/selection.lua")
local context = require("tevgit:workshop/controllers/ui/core/contextMenu.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")

-- store icons for each class type
--  use a table of two icons, 
--   [1] will be unexpanded and [2] will be used when the obj is expanded.
local overridingIcons = {
    script = "fa:s-file-code",
    input = {"fa:s-keyboard", "fa:r-keyboard"},
    debug = "fa:s-bug",
    light = "fa:s-lightbulb",
    block = "fa:s-cube",
    camera = "fa:s-camera",
}

-- dictionary of buttons to their corrosponding objects.
local buttonToObject = {}

local function updatePositions(frame)
    local y = 10
    if not frame then
        frame = controller.scrollView
    else
        y = 20
    end

    if frame.children then
        for _, v in pairs(frame.children) do
            if v.name ~= "icon" then
                v.position = guiCoord(0, 10, 0, y)
                y = y + updatePositions(v)
            end
        end
    end

    if type(frame) == "guiTextBox" then

        local regularIconWithChildren = "fa:s-folder"
        local regularIconWithOutChildren = "fa:r-folder"
        local expandedIcon = "fa:s-folder-open"

        local icons = overridingIcons[buttonToObject[frame].className]
        if icons then
            if type(icons) == "string" then
                regularIconWithChildren = icons
                regularIconWithOutChildren = icons
            else
                regularIconWithChildren = icons[1]
                regularIconWithOutChildren = icons[1]
                expandedIcon = icons[2]
            end
        end

        if y == 20 then
            -- no children
            if buttonToObject[frame] and buttonToObject[frame].children and
                #buttonToObject[frame].children > 0 then
                -- object has children but is not expanded
                frame.icon.texture = regularIconWithChildren
                frame.icon.imageAlpha = 1
                frame.textAlpha = 1
                frame.fontFile = "local:OpenSans-SemiBold.ttf"
            else
                -- object has no children
                frame.icon.texture = regularIconWithOutChildren
                frame.icon.imageAlpha = 0.5
                frame.textAlpha = .6
                frame.fontFile = "local:OpenSans-Regular.ttf"
            end
        else
            -- object is expanded
            frame.textAlpha = 0.6
            frame.fontFile = "local:OpenSans-Regular.ttf"
            frame.icon.imageAlpha = 0.75
            frame.icon.texture = expandedIcon
        end

        if buttonToObject[frame] and selection.isSelected(buttonToObject[frame]) then
            frame.backgroundAlpha = 0.3
        else
            frame.backgroundAlpha = 0
        end
    end

    return y
end

controller.updatePositions = updatePositions

local function createHierarchyButton(object, guiParent)
    local btn = ui.create("guiTextBox", guiParent, {
        text = "       " .. object.name, -- ik...
        size = guiCoord(1, -6, 0, 18),
        fontSize = 16,
        cropChildren = false,
        backgroundAlpha = 0,
        hoverCursor = "fa:s-hand-pointer"
    }, "backgroundText")

    buttonToObject[btn] = object

    local icon = ui.create("guiImage", btn, {
        name = "icon",
        texture = "fa:s-folder",
        position = guiCoord(0, 1, 0, 1),
        size = guiCoord(0, 16, 0, 16),
        handleEvents = false,
        backgroundAlpha = 0
    })

    local expanded = false
    local lastClick = 0

    btn:onSync("mouseRightPressed", function()
        if (object:isA("folder")) then
            selection.setSelection(object.children)
            propertyEditor.generateProperties(object)
        else
            selection.setSelection({object})
        end
        controller.scrollView.canvasSize = guiCoord(1, 0, 0, updatePositions())
    end)

    btn:mouseLeftReleased(function()
        if os.time() - lastClick < 0.35 then
            lastClick = 0
            -- expand
            expanded = not expanded
            if expanded then
                for _, child in pairs(object.children) do
                    createHierarchyButton(child, btn)
                end
                controller.scrollView.canvasSize =
                    guiCoord(1, 0, 0, updatePositions())
                if object.className == "script" then
                    object:editExternal()
                    -- require("tevgit:create/controllers/scriptController.lua").editScript(object)
                end
            else
                for _, v in pairs(btn.children) do
                    if v.name ~= "icon" then
                        if buttonToObject[v] then
                            buttonToObject[v] = nil
                        end
                        v:destroy()
                    end
                end
                controller.scrollView.canvasSize =
                    guiCoord(1, 0, 0, updatePositions())
            end
        else
            -- single click
            local currentTime = os.time()
            lastClick = currentTime

            if (object:isA("folder")) then
                selection.setSelection(object.children)
                propertyEditor.generateProperties(object)
            else
                selection.setSelection(object)
            end

            controller.scrollView.canvasSize =
                guiCoord(1, 0, 0, updatePositions())
        end
    end)

    local childAddedEvent = object:on("childAdded", function(child)
        if expanded then createHierarchyButton(child, btn) end
        controller.scrollView.canvasSize = guiCoord(1, 0, 0, updatePositions())
    end)

    local childRemovedEvent = object:onSync("childRemoved", function(child)
        if expanded then
            for button, obj in pairs(buttonToObject) do
                if obj == child and button.alive then
                    button:destroy()
                end
            end
        end
        controller.scrollView.canvasSize = guiCoord(1, 0, 0, updatePositions())
    end)

    btn:once("destroying", function() childAddedEvent:disconnect() end)

    if object:isA("luaSharedFolder") 
       or object:isA("luaServerFolder")
       or object:isA("luaClientFolder") then
        context.bind(btn, {
            {name = "Add Script", callback = function() engine.construct("script", object) end}
        })
    else
        -- selectionController.applyContext(btn)
    end
    return btn
end

controller.window = ui.window(shared.workshop.interface, "Hierarchy",
    guiCoord(0, 260, 0, 400), -- size
    guiCoord(1, -260, 0.75, -25), -- pos
    true, -- dockable
    true -- hidable
)
controller.window.visible = true

controller.scrollView = ui.create("guiScrollView", controller.window.content, {
    name = "scrollview",
    size = guiCoord(1, 0, 1, 0)
}, "primaryText")

createHierarchyButton(engine, controller.scrollView)
controller.scrollView.canvasSize = guiCoord(1, 0, 0, updatePositions())

return controller
