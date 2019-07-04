local controller = {}
local uiController = require("tevgit:create/controllers/ui.lua")
local themeController = require("tevgit:create/controllers/theme.lua")
local colourPickerController = require("tevgit:create/extras/colourPicker.lua")
local dockController = require("tevgit:create/controllers/dock.lua")

local meshShorcuts = {
  cube = "primitive:cube",
  sphere = "primitive:sphere",
  cylinder = "primitive:cylinder",
  torus = "primitive:torus",
  cone = "primitive:cone",
  wedge = "primitive:wedge",
  corner = "primitive:corner",
  worker = "tevurl:3d/worker.glb",
  duck = "tevurl:3d/Duck.glb",
  avocado = "tevurl:3d/Avocado.glb",
}

controller.window = nil
controller.workshop = nil
controller.scrollView = nil

controller.excludePropertyList = {}

controller.colourPicker = nil

function controller.createUI(workshop)
  controller.workshop = workshop
  controller.colourPicker = colourPickerController.create()
  controller.colourPicker.window.visible = false
	controller.window = uiController.createWindow(workshop.interface, guiCoord(1, -300, 1, -400), guiCoord(0, 250, 0, 400), "Properties")
  controller.window.visible = true

  dockController.dockWindow(controller.window, dockController.rightDock)
  
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
    --local x,y,z,w = tonumber(gui.x.text),tonumber(gui.y.text),tonumber(gui.z.text),tonumber(gui.w.text)
    local x,y,z = tonumber(gui.x.text),tonumber(gui.y.text),tonumber(gui.z.text)
    if x and y and z then
      callbackInput(property, quaternion():setEuler(math.rad(x),math.rad(y),math.rad(z)))
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
    gui.x.text = string.format("%.3f", value.x)
    gui.y.text = string.format("%.3f", value.y)
    gui.z.text = string.format("%.3f", value.z)
  end,
  vector2 = function(instance, gui, value)
    gui.x.text = string.format("%.3f", value.x)
    gui.y.text = string.format("%.3f", value.y)
  end,
  colour = function(instance, gui, value)
    gui.r.text = tostring(value.r)
    gui.g.text = tostring(value.g)
    gui.b.text = tostring(value.b)
    gui.col.backgroundColour = value
  end,
  quaternion = function(instance, gui, value)
    local euler = value:getEuler()
    gui.x.text = string.format("%.3f", math.deg(euler.x))
    gui.y.text = string.format("%.3f", math.deg(euler.y))
    gui.z.text = string.format("%.3f", math.deg(euler.z))
    --gui.w.text = tostring(value.w)
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
      size = guiCoord(0.5, 0, 0, 20),
      position = guiCoord(0.5,0,0,0),
      cropChildren = false
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
      size = guiCoord(0, 18, 1, -2),
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
      size = guiCoord(1, -4, 0, 18),
      position = guiCoord(0, 2, 0, 1),
      text = "0",
      align = enums.align.middle
    }, "primary")

    x:textInput(function ()
      controller.parseInputs[type(value)](property, container)
    end)

  if property == "type" and type(instance) == "light" then
      container.zIndex = 30 -- important because child elements need to be rendered above other properties!
      container.size = container.size + guiCoord(0,0,0,20)


      local presetSelect = uiController.create("guiTextBox", container, {
          size = guiCoord(1, -4, 0, 16),
          position = guiCoord(0, 2, 0, 23),
          borderRadius = 3,
          text = "Light Options",
          fontSize = 16,
          align = enums.align.middle,
          alpha = 0.75
      }, "primary")

      local optionsModal = uiController.create("guiFrame", container, {
          position = guiCoord(-0.8, 7, 0, 48),
          borderRadius = 6,
          visible = false,
          zIndex = 40,
          borderWidth = 1,
          cropChildren = false
      }, "main")

      local isFocused = false
      local pendingHide = false
      local function queueCloseModal()
        if not pendingHide and optionsModal.visible then
          pendingHide = true
          wait(.4)
          if not isFocused then
            --still unfocused, lets hide.
            optionsModal.visible = false
          end
          pendingHide=false
        end
      end

      presetSelect:mouseFocused(function ()
        optionsModal.visible = true
        isFocused = true
      end)

      optionsModal:mouseFocused(function ()
        isFocused = true
      end)

      presetSelect:mouseUnfocused(function ()
        isFocused = false
        queueCloseModal()
      end)

      optionsModal:mouseUnfocused(function ()
        isFocused = false
        queueCloseModal()
      end)

      uiController.create("guiImage", optionsModal, {
        size = guiCoord(0, 24, 0, 24),
        position = guiCoord(0.75, -12, 0, -15),
        handleEvents=false,
        zIndex = 10,
        texture = "fa:s-caret-up",
        imageColour = optionsModal.backgroundColour
      })

      local curY = 0
      local curX = 0
      for lightType, num in pairs(enums.lightType) do

        local btn = uiController.create("guiTextBox", optionsModal, {
          size = guiCoord(.5, -10, 0, 18),
          position = guiCoord(curX, 5, 0, curY + 4),
          borderRadius = 3,
          text = lightType,
          fontSize = 16,
          align = enums.align.middle
        }, "primary")

        btn:mouseFocused(function ()
          isFocused = true
        end)
        btn:mouseUnfocused(function ()
          isFocused = false
          queueCloseModal()
        end)
        btn:mouseLeftReleased(function ()
          x.text = tostring(num)
          controller.parseInputs[type(value)](property, container)
        end)

        if curX == 0.5 then
          curY = curY + 24
          curX = 0
        else
          curX = 0.5
        end
      end

      if curX == 0.5 then
        curY = curY + 24
      end

      optionsModal.size = guiCoord(1.8, -10, 0, curY+4)


    end

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
      size = guiCoord(1, -4, 0, 18),
      position = guiCoord(0, 2, 0, 1),
      text = "text input",
      align = enums.align.middleLeft,
      zIndex = 2
    }, "primary")

    x:textInput(function ()
      controller.parseInputs[type(value)](property, container)
    end)

    -- TODO TODO TODO TODO 
    -- We need some sort of helper function that'll make 
    -- modals for situations like this:

    if property == "mesh" then
      container.zIndex = 30 -- important because child elements need to be rendered above other properties!
      container.size = container.size + guiCoord(0,0,0,20)


      local presetSelect = uiController.create("guiTextBox", container, {
          size = guiCoord(1, -4, 0, 16),
          position = guiCoord(0, 2, 0, 23),
          borderRadius = 3,
          text = "Mesh Presets",
          fontSize = 16,
          align = enums.align.middle,
          alpha = 0.75
      }, "primary")

      local meshModal = uiController.create("guiFrame", container, {
          position = guiCoord(-0.8, 7, 0, 48),
          borderRadius = 6,
          visible = false,
          zIndex = 40,
          borderWidth = 1,
          cropChildren = false
      }, "main")

      local isFocused = false
      local pendingHide = false
      local function queueCloseModal()
        if not pendingHide and meshModal.visible then
          pendingHide = true
          wait(.4)
          if not isFocused then
            --still unfocused, lets hide.
            meshModal.visible = false
          end
          pendingHide=false
        end
      end

      presetSelect:mouseFocused(function ()
        meshModal.visible = true
        isFocused = true
      end)

      meshModal:mouseFocused(function ()
        isFocused = true
      end)

      presetSelect:mouseUnfocused(function ()
        isFocused = false
        queueCloseModal()
      end)

      meshModal:mouseUnfocused(function ()
        isFocused = false
        queueCloseModal()
      end)

      uiController.create("guiImage", meshModal, {
        size = guiCoord(0, 24, 0, 24),
        position = guiCoord(0.75, -12, 0, -15),
        handleEvents=false,
        zIndex = 10,
        texture = "fa:s-caret-up",
        imageColour = meshModal.backgroundColour
      })

      local curY = 0
      local curX = 0
      for meshName, actualMeshName in pairs(meshShorcuts) do

        local btn = uiController.create("guiTextBox", meshModal, {
          size = guiCoord(.5, -10, 0, 18),
          position = guiCoord(curX, 5, 0, curY + 4),
          borderRadius = 3,
          text = meshName,
          fontSize = 16,
          align = enums.align.middle
        }, "primary")

        btn:mouseFocused(function ()
          isFocused = true
        end)
        btn:mouseUnfocused(function ()
          isFocused = false
          queueCloseModal()
        end)
        btn:mouseLeftReleased(function ()
          x.text = actualMeshName
          controller.parseInputs[type(value)](property, container)
        end)

        if curX == 0.5 then
          curY = curY + 24
          curX = 0
        else
          curX = 0.5
        end
      end

      if curX == 0.5 then
        curY = curY + 24
      end

      meshModal.size = guiCoord(1.8, -10, 0, curY+4)


    end

    return container
  end,

  vector3 = function(instance, property, value)
    local container = controller.createInput.default(value, pType, readOnly)
    container.size = guiCoord(container.size.scaleX, 0, 0, 60)

    local xLabel = uiController.create("guiTextBox", container, {
      name = "labelX",
      size = guiCoord(0, 10, 1/3, -1),
      position = guiCoord(0,-10,0,1),
      fontSize = 16,
      textAlpha = 0.6,
      text = "X",
      align = enums.align.topLeft
    }, "mainText")
    
    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "x",
      size = guiCoord(1, -4, 1/3, -1),
      position = guiCoord(0, 2, 0, 0),
      text = "0",
      align = enums.align.middle
    }, "primary")

    local yLabel = xLabel:clone()
    yLabel.name = "yLabel"
    yLabel.text = "Y"
    yLabel.parent = container
    yLabel.position = guiCoord(0, -10, 1/3, 1)
    themeController.add(yLabel, "mainText")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(0, 2, 1/3, 0)
    themeController.add(y, "primary")

    local zLabel = xLabel:clone()
    zLabel.name = "zLabel"
    zLabel.text = "Z"
    zLabel.parent = container
    zLabel.position = guiCoord(0, -10, 2/3, 1)
    themeController.add(yLabel, "mainText")

    local z = x:clone()
    z.name = "z"
    z.parent = container
    z.position = guiCoord(0, 2, 2/3, 0)
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
    container.size = guiCoord(container.size.scaleX, 0, 0, 40)

    local xLabel = uiController.create("guiTextBox", container, {
      name = "labelX",
      size = guiCoord(0, 10, 1/2, -1),
      position = guiCoord(0,-10,0,2),
      fontSize = 16,
      textAlpha = 0.6,
      text = "X",
      align = enums.align.topLeft
    }, "mainText")

    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "x",
      size = guiCoord(0, -4, 1/2, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "0",
      align = enums.align.middle
    }, "primary")

    local yLabel = xLabel:clone()
    yLabel.name = "yLabel"
    yLabel.text = "Y"
    yLabel.parent = container
    yLabel.position = guiCoord(0, -10, 1/2, 2)
    themeController.add(yLabel, "mainText")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(0, 2, 1/2, 1)
    themeController.add(y, "primary")
    local function handler()
      controller.parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)

    return container
  end,

  quaternion = function(instance, property, value)

    -- maybe quaternions need an Euler editor?

    local container = controller.createInput.default(value, pType, readOnly)
    container.size = guiCoord(container.size.scaleX, 0, 0, 60)

    local xLabel = uiController.create("guiTextBox", container, {
      name = "labelX",
      size = guiCoord(0, 12, 1/3, -1),
      position = guiCoord(0,-10,0,1),
      fontSize = 16,
      textAlpha = 0.6,
      text = "X",
      align = enums.align.topLeft
    }, "mainText")

    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "x",
      size = guiCoord(1, -4, 1/3, -1),
      position = guiCoord(0, 2, 0, 0),
      text = "0",
      align = enums.align.middle
    }, "primary")

    local yLabel = xLabel:clone()
    yLabel.name = "yLabel"
    yLabel.text = "Y"
    yLabel.parent = container
    yLabel.position = guiCoord(0, -10, 1/3, 1)
    themeController.add(yLabel, "mainText")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(0, 2, 1/3, 0)
    themeController.add(y, "primary")

    local zLabel = xLabel:clone()
    zLabel.name = "zLabel"
    zLabel.text = "Z"
    zLabel.parent = container
    zLabel.position = guiCoord(0, -10, 2/3, 1)
    themeController.add(zLabel, "mainText")

    local z = x:clone()
    z.name = "z"
    z.parent = container
    z.position = guiCoord(0, 2, 2/3, 0)
    themeController.add(z, "primary")

    --[[local wLabel = xLabel:clone()
    wLabel.name = "wLabel"
    wLabel.text = "W"
    wLabel.parent = container
    wLabel.position = guiCoord(0, -12, 3/4, 2)
    themeController.add(wLabel, "mainText")

    local w = x:clone()
    w.name = "w"
    w.parent = container
    w.position = guiCoord(0, 2, 3/4, 1)
    themeController.add(w, "primary")]]

    local function handler()
      controller.parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)
    z:textInput(handler)
    --w:textInput(handler)

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
    container.size = guiCoord(container.size.scaleX, 0, 0, 60)

    local rLabel = uiController.create("guiTextBox", container, {
      name = "labelR",
      size = guiCoord(0, 10, 1/3, -1),
      position = guiCoord(0,-10,0,2),
      fontSize = 16,
      textAlpha = 0.6,
      text = "R",
      align = enums.align.topLeft
    }, "mainText")

    local x = uiController.create("guiTextBox", container, {
      alpha = 0.25,
      readOnly = false,
      multiline = false,
      fontSize = 18,
      name = "r",
      size = guiCoord(1, -24, 1/3, -2),
      position = guiCoord(0, 2, 0, 1),
      text = "1",
      align = enums.align.middle
    }, "primary")

    local gLabel = rLabel:clone()
    gLabel.name = "gLabel"
    gLabel.text = "G"
    gLabel.parent = container
    gLabel.position = guiCoord(0, -10, 1/3, 1)
    themeController.add(gLabel, "mainText")

    local g = x:clone()
    g.name = "g"
    g.parent = container
    g.position = guiCoord(0, 2, 1/3, 1)
    themeController.add(g, "primary")

    local bLabel = rLabel:clone()
    bLabel.name = "bLabel"
    bLabel.text = "B"
    bLabel.parent = container
    bLabel.position = guiCoord(0, -10, 2/3, 1)
    themeController.add(bLabel, "mainText")

    local b = x:clone()
    b.name = "b"
    b.parent = container
    b.position = guiCoord(0, 2, 2/3, 1)
    themeController.add(b, "primary")

    local function handler()
      controller.parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    g:textInput(handler)
    b:textInput(handler)

    local col = engine.construct("guiFrame", container, {
      name = "col",
      size = guiCoord(0, 14, 1, -2),
      position = guiCoord(1, -18, 0, 1),
      backgroundColour = colour(1,1,1),
      borderRadius = 2,
    })

    col:mouseLeftReleased(function ()
      controller.colourPicker.window.visible  = not controller.colourPicker.window.visible 
      if controller.colourPicker.window.visible then
        controller.colourPicker.setColour(instance[property])
      end
    end)

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
            
            --letting the user turn physics off would cause raycasts to die.

            if not readOnly and pType ~= "function" and v.property ~= "physics" and v.property ~= "doNotSerialise" and not controller.excludePropertyList[v.property] then

              local container = controller.scrollView["_" .. v.property]

              if not container then
                container = engine.construct("guiFrame", controller.scrollView,
                {
                  name = "_" .. v.property,
                  alpha = 0,
                  size = guiCoord(1, -10, 0, 20),
                  cropChildren = false
                })

                label = uiController.create("guiTextBox", container, {
                	name = "label",
                	size = guiCoord(0.5, -15, 1, 0),
                	position = guiCoord(0,0,0,0),
                	fontSize = 18,
                	text = v.property,
                  align = enums.align.topRight
                }, "mainText")

                local inputGui = nil
              	
              	if controller.createInput[pType] then
              		inputGui = controller.createInput[pType](instance, v.property, value)
              	else
              		inputGui = controller.createInput.default(instance, v.property, value)		
              	end

                container.size = guiCoord(1, -10, 0, inputGui.size.offsetY)
                container.zIndex = inputGui.zIndex
                inputGui.parent = container
              else
                container.visible = true
              end


              if controller.updateHandlers[pType] then
                controller.updateHandlers[pType](instance, container.inputContainer, value)

              end

              container.position = guiCoord(0,5,0,y)

            	y = y + container.size.offsetY + 3
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