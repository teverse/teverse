-- these functions are responsible for updating the property editor gui
-- when the selection’s members are updated by 3rd party source 

local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")

return {
  block = function (instance, gui, value)

  end,
  boolean = function (instance, gui, value)
    if engine.input.keyFocusedGui == gui.input then return end

    gui.input.texture = value and "fa:s-toggle-on" or "fa:s-toggle-off"
    themer.registerGui(gui.input, value and "successImage" or "errorImage")
  end,
  number = function (instance, gui, value)
    if engine.input.keyFocusedGui == gui.input then return end

    gui.input.text = string.format("%.3f", value)
  end,
  string = function (instance, gui, value)
    if engine.input.keyFocusedGui == gui.input then return end

    gui.input.text = value
  end,
  vector3 = function(instance, gui, value)
    if engine.input.keyFocusedGui == gui.x or engine.input.keyFocusedGui == gui.y or engine.input.keyFocusedGui == gui.z then return end

    gui.x.text = string.format("%.3f", value.x)
    gui.y.text = string.format("%.3f", value.y)
    gui.z.text = string.format("%.3f", value.z)
  end,
  vector2 = function(instance, gui, value)
    if engine.input.keyFocusedGui == gui.x or engine.input.keyFocusedGui == gui.y then return end

    gui.x.text = string.format("%.3f", value.x)
    gui.y.text = string.format("%.3f", value.y)
  end,
  colour = function(instance, gui, value)
    if engine.input.keyFocusedGui == gui.r or engine.input.keyFocusedGui == gui.g or engine.input.keyFocusedGui == gui.b then return end

    gui.r.text = string.format("%.0f", value.r * 255)
    gui.g.text = string.format("%.0f", value.g * 255)
    gui.b.text = string.format("%.0f", value.b * 255)
    gui.col.backgroundColour = value
  end,
  quaternion = function(instance, gui, value)
    if engine.input.keyFocusedGui == gui.x or engine.input.keyFocusedGui == gui.y or engine.input.keyFocusedGui == gui.z then return end

    local euler = value:getEuler()
    gui.x.text = string.format("%.3f", math.deg(euler.x))
    gui.y.text = string.format("%.3f", math.deg(euler.y))
    gui.z.text = string.format("%.3f", math.deg(euler.z))
    --gui.w.text = tostring(value.w)
  end,
  guiCoord = function(instance, gui, value)
    if engine.input.keyFocusedGui == gui.scaleX or engine.input.keyFocusedGui == gui.offsetX or engine.input.keyFocusedGui == gui.scaleY or engine.input.keyFocusedGui == gui.offsetY then return end
    
    gui.scaleX.text = tostring(value.scaleX)
    gui.offsetX.text = tostring(value.offsetX)
    gui.scaleY.text = tostring(value.scaleY)
    gui.offsetY.text = tostring(value.offsetY)
  end,
}