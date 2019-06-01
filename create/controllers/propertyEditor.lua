local controller = {}
local uiController = require("tevgit:create/controllers/ui.lua")

controller.window = nil
controller.workshop = nil

function controller.createUI(workshop)
  controller.workshop = workshop
	controller.window = uiController.create("guiFrame", workshop.interface, {
		name = "propertyWindow",
		draggable = true,
		size = guiCoord(0, 250, 0, 400),
		position = guiCoord(1, -250, 1, -400)
	}, "main")
end

controller.createInput = {
	default = function(value, pType, readOnly)
    return uiController.create("guiFrame", nil, {
      alpha = 0.25,
      size = guiCoord(0.5, -10, 0, 20)
    }, "secondary")
  end,

  block = function(value, pType, readOnly)
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

  boolean = function(value, pType, readOnly)
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

  number = function(value, pType, readOnly)
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

  string = function(value, pType, readOnly)
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
      align = enums.align.middle
    }, "primary")

    return container
  end,

  vector3 = function(value, pType, readOnly)
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

  vector2 = function(value, pType, readOnly)
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

  quaternion = function(value, pType, readOnly)
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

  guiCoord = function(value, pType, readOnly)
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

  colour = function(value, pType, readOnly)
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
       	
       	-- unsure if destroyallchildren is implemented on this instance
       	for _,v in pairs(controller.window.children) do
       		v:destroy()
       	end
       	wait(.1)
       	local y = 10
       	
        for i, v in pairs(members) do
            local value = instance[v.property]
            local pType = type(value)
            local readOnly = not v.writable
            
            if not readOnly and pType ~= "function" then
            	local label = uiController.create("guiTextBox", controller.window, {
            		name = "label" .. v.property,
            		size = guiCoord(0.5, -15, 0, 20),
            		position = guiCoord(0,10,0,y),
            		fontSize = 18,
            		text = v.property,
                align = enums.align.middleRight
            	}, "main")

              local inputGui = nil
            	
            	if controller.createInput[pType] then
            		inputGui = controller.createInput[pType](value,pType, readOnly)
            	else
            		inputGui = controller.createInput.default(value, pType, readOnly)		
            	end
            	
              inputGui.position = guiCoord(0.5, 0, 0, y)
              inputGui.parent = controller.window

            	y = y + 23
            end
        end
    end
end

return controller