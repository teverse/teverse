local shared = require("tevgit:workshop/controllers/shared.lua")
local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local keybinder = require("tevgit:workshop/controllers/core/keybinder.lua")
local history = shared.controllers.history

local window = ui.create("guiFrame", shared.workshop.interface["_toolBar"], {
    size = guiCoord(0, 32, 0, 100),
    position = guiCoord(0, 40, 0, 0),
    backgroundAlpha = 0.8,
    borderRadius = 4
}, "primary")

local function insert(mesh)
    if not mesh then
        mesh = "primitive:cube"
    end

    local insertPos = vector3(0, 0, 0)
    
    local hit = engine.physics:rayTestScreen(engine.input.screenSize/2) -- what's in the centre of the screen?
    if hit then
        local hitDist = (shared.controllers.env.camera.camera.position - hit.hitPosition):length()
        if hitDist < 1 or hitDist > 40 then
            insertPos = shared.controllers.env.camera.camera.position + (shared.controllers.env.camera.camera.rotation * vector3(0, 0, 10))
        else
            insertPos = hit.hitPosition + vector3(0, 0.5, 0)
        end
    else
        insertPos = shared.controllers.env.camera.camera.position + (shared.controllers.env.camera.camera.rotation * vector3(0, 0, 10))
    end

    return engine.construct("block", workspace, {
        mesh = mesh,
        colour = colour(0.8, 0.8, 0.8),
        position = insertPos
    })
end

local adders = {
    {
        name = "Cube",
        icon = "fa:s-cube",
        callback = function()
            insert()
        end
    },
    {
        name = "Sphere",
        icon = "fa:s-globe",
        callback = function()
            insert("primitive:sphere")
        end
    }
}


local currentY = 5
local toolIndex = 0
for _, options in pairs(adders) do

   -- used to assign a number keybind to each tool
   toolIndex = toolIndex + 1

	-- options is the table returned by the tool's module.
	-- e.g. workshop/controllers/sidetools/hand.lua

   local newTabBtn = ui.create("guiTextBox", window, {
      text     = options.name,
      position = guiCoord(0, 4, 0, currentY),
      size     = guiCoord(0, 24, 0, 24),
      hoverCursor = "fa:s-hand-pointer"
   }, "primaryText")
   
   if options.icon then
      newTabBtn.text = ""
      ui.create("guiImage", newTabBtn, {
         name = "icon",
         size = guiCoord(1, 0, 1, 0),
         position = guiCoord(0, 0, 0., 0),
         texture = options.icon,
         handleEvents = false,
         imageAlpha = 0.75
      }, "primaryImage")
   end

   local keybindText = ""
   if toolIndex < 10 then
      keybindText = " [ALT + " .. toolIndex .. "]"

      keybinder:bind({
         name = "Insert " .. options.name .. " shape",
         priorKey = enums.key.alt,
         key = enums.key["number"..toolIndex],
         action = options.callback
      })
   end
   -- shows a tool tip if the user hovers over the button
   ui.tooltip(newTabBtn, options.name .. keybindText)

   newTabBtn:mouseLeftPressed(options.callback)

   currentY = currentY + 32
end

window.size = guiCoord(0, 32, 0, currentY - 5)

return window