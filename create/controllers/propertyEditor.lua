local controller = {}
local uiController = require("tevgit:create/controllers/ui.lua")

controller.window = nil
controller.workshop = nil

function controller.createUI(workshop)
  controller.workshop = workshop
	controller.window = uiController.createWindow(workshop.interface, guiCoord(1, -250, 1, -400), guiCoord(0, 250, 0, 400), "Properties")
end

-- these methods are responsible for setting the propertie gui values when updated 

controller.updateHandlers = {
  vector3 = function(instance, gui, value)
    gui.x.text = tostring(value.x)
    gui.y.text = tostring(value.y)
    gui.z.text = tostring(value.z)
  end,
  colour = function(instance, gui, value)
    gui.r.text = tostring(value.r)
    gui.g.text = tostring(value.g)
    gui.b.text = tostring(value.b)
    gui.col.backgroundColour = colour(tostring(value.r),tostring(value.g),tostring(value.b))
  end
}

controller.createInput = {
	default = function(instance, property, value)
    return uiController.create("guiFrame", nil, {
      alpha = 0.25,
      name = "inputContainer",
      size = guiCoord(0.5, 0, 0, 20),
      position = guiCoord(0.5,0,0,0)
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
      size = guiCoord(1, -4, 1, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "",
      guiStyle = enums.guiStyle.checkBox
    }, "light")

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

    local z = x:clone()
    z.name = "z"
    z.parent = container
    z.position = guiCoord(2/3, 2, 0, 1)

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

    local z = x:clone()
    z.name = "z"
    z.parent = container
    z.position = guiCoord(1/2, 2, 0, 1)

    local w = x:clone()
    w.name = "w"
    w.parent = container
    w.position = guiCoord(3/4, 2, 0, 1)

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

    local z = x:clone()
    z.name = "scaleY"
    z.parent = container
    z.position = guiCoord(1/2, 2, 0, 1)

    local w = x:clone()
    w.name = "offsetY"
    w.parent = container
    w.position = guiCoord(3/4, 2, 0, 1)

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

    local b = x:clone()
    b.name = "b"
    b.parent = container
    b.position = guiCoord(1/2, 2, 0, 1)

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

function controller.generateProperties(instance)
    if instance and instance.events and instance.events["changed"] then
        local members = controller.workshop:getMembersOfInstance( instance )
        table.sort( members, alphabeticalSorter ) 
       	
       	-- prototype teverse gui system isn't perfect,
        -- reuse already created instances to save time.

       	for _,v in pairs(controller.window.content.children) do
       		v.visible = false
       	end

       	local y = 10
       	
        for i, v in pairs(members) do
            local value = instance[v.property]
            local pType = type(value)
            local readOnly = not v.writable
            
            if not readOnly and pType ~= "function" then

              local container = controller.window.content["_" .. v.property]

              if not container then
                container = engine.construct("guiFrame", controller.window.content,
                {
                  name = "_" .. v.property,
                  alpha = 0,
                  size = guiCoord(1, -10, 0, 20)
                })

                label = uiController.create("guiTextBox", container, {
                	name = "label",
                	size = guiCoord(0.5, -10, 0, 20),
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
    end
end

return controller