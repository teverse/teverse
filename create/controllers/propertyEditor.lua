local controller = {}
local uiController = require("tevgit:create/controllers/ui.lua")
local themeController = require("tevgit:create/controllers/theme.lua")

controller.window = nil
controller.workshop = nil
controller.scrollView = nil

controller.excludePropertyList = {}

function controller.createUI(workshop)
  controller.workshop = workshop
	controller.window = uiController.createWindow(workshop.interface, guiCoord(1, -250, 1, -400), guiCoord(0, 250, 0, 400), "Properties")
  controller.window.visible = false
  
  controller.scrollView = uiController.create("guiScrollView", controller.window.content, {
    name = "scrollview",
    size = guiCoord(1,0,1,0)
  }, "mainTopBar")

  local toolsController = require("tevgit:create/controllers/tool.lua")
  local propertiesBtn = toolsController.createButton("windowsTab", "fa:s-sliders-h", "Properties")
  propertiesBtn:mouseLeftReleased(function ()
    controller.window.visible = not controller.window.visible
  end)
end

local instanceEditing = nil
local function callbackInput(property, value)
  if instanceEditing and instanceEditing[property] ~= nil then
    instanceEditing[property] = value
  end
end

controller.parseInputs = {
  block = function (property, gui)

  end,
  boolean = function (property, gui)
    callbackInput(property, gui.input.selected == true)
  end,
  number = function (property, gui)
    local num = tonumber(gui.input.text)
    if num then
      callbackInput(property, num)
    end
  end,
  string = function (property, gui)
    callbackInput(property, gui.input.text)
  end,
  vector3 = function(property, gui)
    local x,y,z = tonumber(gui.x.text),tonumber(gui.y.text),tonumber(gui.z.text)
    if x and y and z then
      callbackInput(property, vector3(x,y,z))
    end
  end,
  vector2 = function(property, gui)
    local x,y = tonumber(gui.x.text),tonumber(gui.y.text)
    if x and y then
      callbackInput(property, vector2(x,y))
    end
  end,
  colour = function(property, gui)
    local r,g,b = tonumber(gui.r.text),tonumber(gui.g.text),tonumber(gui.b.text)
    if r and g and b then
      callbackInput(property, colour(r,g,b))
    end
  end,
  quaternion = function(property, gui)
    local x,y,z,w = tonumber(gui.x.text),tonumber(gui.y.text),tonumber(gui.z.text),tonumber(gui.w.text)
    if x and y and z and w then
      callbackInput(property, quaternion(x,y,z,w))
    end
  end,
  guiCoord = function(property, gui)
    local sx,ox,sy,oy = tonumber(gui.scaleX.text),tonumber(gui.offsetX.text),tonumber(gui.scaleY.text),tonumber(gui.offsetY.text)
    if sx and ox and sy and oy then
      callbackInput(property, guiCoord(sx,ox,sy,oy))
    end
  end,
}

-- these methods are responsible for setting the propertie gui values when updated 

controller.updateHandlers = {
  block = function (instance, gui, value)

  end,
  boolean = function (instance, gui, value)
    gui.input.selected = value
  end,
  number = function (instance, gui, value)
    gui.input.text = tostring(value)
  end,
  string = function (instance, gui, value)
    gui.input.text = value
  end,
  vector3 = function(instance, gui, value)
    gui.x.text = tostring(value.x)
    gui.y.text = tostring(value.y)
    gui.z.text = tostring(value.z)
  end,
  vector2 = function(instance, gui, value)
    gui.x.text = tostring(value.x)
    gui.y.text = tostring(value.y)
  end,
  colour = function(instance, gui, value)
    gui.r.text = tostring(value.r)
    gui.g.text = tostring(value.g)
    gui.b.text = tostring(value.b)
    gui.col.backgroundColour = value
  end,
  quaternion = function(instance, gui, value)
    gui.x.text = tostring(value.x)
    gui.y.text = tostring(value.y)
    gui.z.text = tostring(value.z)
    gui.w.text = tostring(value.w)
  end,
  guiCoord = function(instance, gui, value)
    gui.scaleX.text = tostring(value.scaleX)
    gui.offsetX.text = tostring(value.offsetX)
    gui.scaleY.text = tostring(value.scaleY)
    gui.offsetY.text = tostring(value.offsetY)
  end,
}

controller.createInput = {
	default = function(instance, property, value)
    return uiController.create("guiFrame", nil, {
      alpha = 0.25,
      name = "inputContainer",
      size = guiCoord(0.6, 0, 0, 20),
      position = guiCoord(0.4,0,0,0)
    }, "secondary")
  end,

  block = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = true,
      fontSize = 18,
      name = "input",
      size = guiCoord(1, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "Instance Selector",
      align = enums.align.middle
    }, "primary")



    return container
  end,

  boolean = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiButton", container, {
      name = "input",
      size = guiCoord(0, 20, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "",
      alpha = 0.75,
      guiStyle = enums.guiStyle.checkBox
    }, "light")

    x:mouseLeftReleased(function ()
      x.selected = not x.selected
      controller.parseInputs[type(value)](property, container)
    end)

    return container
  end,

  number = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "input",
      size = guiCoord(1, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "0",
      align = enums.align.middle
    }, "primary")

    x:textInput(function ()
      controller.parseInputs[type(value)](property, container)
    end)

    return container
  end,

  string = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "input",
      size = guiCoord(1, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "text input",
      align = enums.align.middleLeft
    }, "primary")

    x:textInput(function ()
      controller.parseInputs[type(value)](property, container)
    end)

    return container
  end,

  vector3 = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "x",
      size = guiCoord(1/3, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "0",
      align = enums.align.middle
    }, "primary")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(1/3, 2, 0, 1)
    themeController.add(y, "primary")

    local z = x:clone()
    z.name = "z"
    z.parent = container
    z.position = guiCoord(2/3, 2, 0, 1)
    themeController.add(z, "primary")

    local function handler()
      controller.parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)
    z:textInput(handler)

    return container
  end,

  vector2 = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "x",
      size = guiCoord(1/2, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "0",
      align = enums.align.middle
    }, "primary")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(1/2, 2, 0, 1)
    themeController.add(y, "primary")
    local function handler()
      controller.parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)

    return container
  end,

  quaternion = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "x",
      size = guiCoord(1/4, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "0",
      align = enums.align.middle
    }, "primary")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(1/4, 2, 0, 1)
    themeController.add(y, "primary")

    local z = x:clone()
    z.name = "z"
    z.parent = container
    z.position = guiCoord(1/2, 2, 0, 1)
    themeController.add(z, "primary")

    local w = x:clone()
    w.name = "w"
    w.parent = container
    w.position = guiCoord(3/4, 2, 0, 1)
    themeController.add(w, "primary")

    local function handler()
      controller.parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)
    z:textInput(handler)
    w:textInput(handler)

    return container
  end,

  guiCoord = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "scaleX",
      size = guiCoord(1/4, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "0",
      align = enums.align.middle
    }, "primary")

    local y = x:clone()
    y.name = "offsetX"
    y.parent = container
    y.position = guiCoord(1/4, 2, 0, 1)
    themeController.add(y, "primary")

    local z = x:clone()
    z.name = "scaleY"
    z.parent = container
    z.position = guiCoord(1/2, 2, 0, 1)
    themeController.add(z, "primary")

    local w = x:clone()
    w.name = "offsetY"
    w.parent = container
    w.position = guiCoord(3/4, 2, 0, 1)
    themeController.add(w, "primary")

    local function handler()
      controller.parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)
    z:textInput(handler)
    w:textInput(handler)

    return container
  end,

  colour = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "r",
      size = guiCoord(1/4, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "1",
      align = enums.align.middle
    }, "primary")

    local g = x:clone()
    g.name = "g"
    g.parent = container
    g.position = guiCoord(1/4, 2, 0, 1)
    themeController.add(g, "primary")

    local b = x:clone()
    b.name = "b"
    b.parent = container
    b.position = guiCoord(1/2, 2, 0, 1)
    themeController.add(b, "primary")

    local function handler()
      controller.parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    g:textInput(handler)
    b:textInput(handler)

    local col = engine.construct("guiFrame", container, {
      name = "col",
      size = guiCoord(1/4, -4, 1, -2),
      position = guiCoord(3/4, 2, 0, 1),
      backgroundColour = colour(1,1,1)
    })

    return container
  end,
}

local function alphabeticalSorter(a, b)
	return a.property < b.property
end

controller.eventHandlers = {}
controller.instanceEditing = nil

function controller.generateProperties(instance)
  if instanceEditing == instance then return end
  
  instanceEditing = nil
  controller.instanceEditing = nil

  for i,v in pairs(controller.eventHandlers) do
    v:disconnect()
  end
  controller.eventHandlers = {}

    if instance and instance.events and instance.events["changed"] then
        instanceEditing = instance
        controller.instanceEditing = instance

        local members = controller.workshop:getMembersOfInstance( instance )
        table.sort( members, alphabeticalSorter ) 
       	
       	-- prototype teverse gui system isn't perfect,
        -- reuse already created instances to save time.

       	for _,v in pairs(controller.scrollView.children) do
       		v.visible = false
       	end

       	local y = 10
       	
        for i, v in pairs(members) do
            local value = instance[v.property]
            local pType = type(value)
            local readOnly = not v.writable
            
            if not readOnly and pType ~= "function" and v.property ~= "physics" and not controller.excludePropertyList[v.property] then

              local container = controller.scrollView["_" .. v.property]

              if not container then
                container = engine.construct("guiFrame", controller.scrollView,
                {
                  name = "_" .. v.property,
                  alpha = 0,
                  size = guiCoord(1, -10, 0, 20)
                })

                label = uiController.create("guiTextBox", container, {
                	name = "label",
                	size = guiCoord(0.4, -10, 0, 20),
                	position = guiCoord(0,0,0,0),
                	fontSize = 18,
                	text = v.property,
                  align = enums.align.middleRight
                }, "mainText")

                local inputGui = nil
              	
              	if controller.createInput[pType] then
              		inputGui = controller.createInput[pType](instance, v.property, value)
              	else
              		inputGui = controller.createInput.default(instance, v.property, value)		
              	end

                inputGui.parent = container
              else
                container.visible = true
              end

              if controller.updateHandlers[pType] then
                controller.updateHandlers[pType](instance, container.inputContainer, value)

              end

              container.position = guiCoord(0,5,0,y)

            	y = y + 23
            end
        end

        table.insert( controller.eventHandlers, instance:changed(function(prop, val)
          if controller.updateHandlers[type(val)] then
            local container = controller.scrollView["_" .. prop]
            if container then
              controller.updateHandlers[type(val)](instance, container.inputContainer, val)
            end
          end
        end))

        controller.scrollView.canvasSize = guiCoord(0,0,0,y)
    end
end

return controller