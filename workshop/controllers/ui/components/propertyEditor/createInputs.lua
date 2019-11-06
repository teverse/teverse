-- this module is responsible for creating the inputguis

local modulePrefix = "tevgit:workshop/controllers/ui/components/propertyEditor/"

local ui = require("tevgit:workshop/controllers/ui/core/ui.lua")
local themer = require("tevgit:workshop/controllers/ui/core/themer.lua")

local parseInputs = require(modulePrefix .. "parseInputs.lua")
local meshShortcuts = require(modulePrefix .. "meshShortcuts.lua")

local createInputs;

createInputs = {
	default = function(instance, property, value)
    return ui.create("guiFrame", nil, {
      backgroundAlpha = 0.25,
      name = "inputContainer",
      size = guiCoord(0.4, 0, 0, 20),
      position = guiCoord(0.6,0,0,0),
      cropChildren = false
    }, "secondary")
  end,

  block = function(instance, property, value)
    local container = createInputs.default(value, pType, readOnly)
    local x = ui.create("guiTextBox", container, {
      backgroundAlpha = 0.25,
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
    local container = createInputs.default(value, pType, readOnly)
    container.backgroundAlpha = 0
    local x = ui.create("guiImage", container, {
      name = "input",
      size = guiCoord(0, 20, 0, 20),
      position = guiCoord(0, 0, 0, 0),
      texture = "fa:s-toggle-on"
    }, "successImage")

    x:mouseLeftReleased(function ()
      value = not value
      x.texture = value and "fa:s-toggle-on" or "fa:s-toggle-off"
      themer.registerGui(x, value and "successImage" or "errorImage")
      parseInputs[type(value)](property, container)
    end)

    return container
  end,

  number = function(instance, property, value)
    local container = createInputs.default(value, pType, readOnly)
    local x = ui.create("guiTextBox", container, {
      backgroundAlpha = 0.25,
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
      parseInputs[type(value)](property, container)
    end)

  if property == "type" and type(instance) == "light" then
      container.zIndex = 30 -- important because child elements need to be rendered above other properties!
      container.size = container.size + guiCoord(0,0,0,20)


      local presetSelect = ui.create("guiTextBox", container, {
          size = guiCoord(1, -4, 0, 16),
          position = guiCoord(0, 2, 0, 23),
          borderRadius = 3,
          text = "Light Options",
          fontSize = 16,
          align = enums.align.middle,
          backgroundAlpha = 0.75
      }, "primary")

      local optionsModal = ui.create("guiFrame", container, {
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

      ui.create("guiImage", optionsModal, {
        size = guiCoord(0, 24, 0, 24),
        position = guiCoord(0.75, -12, 0, -15),
        handleEvents=false,
        zIndex = 10,
        backgroundAlpha = 0,
        texture = "fa:s-caret-up",
        imageColour = optionsModal.backgroundColour
      })

      local curY = 0
      local curX = 0
      for lightType, num in pairs(enums.lightType) do

        local btn = ui.create("guiTextBox", optionsModal, {
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
          parseInputs[type(value)](property, container)
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

  scriptSource = function(instance, property, value)
    local container = createInputs.default(value, pType, readOnly)
    local presetSelect = ui.create("guiTextBox", container, {
        size = guiCoord(1, -4, 0, 16),
        position = guiCoord(0, 2, 0, 2),
        borderRadius = 3,
        text = "Edit Source",
        fontSize = 16,
        align = enums.align.middle,
        backgroundAlpha = 0.75
    }, "primary")
    presetSelect:mouseLeftReleased(function ()
      if instance[property] then
        instance[property]:editExternal()
      end
    end)

    return container
  end,

  string = function(instance, property, value)
    local container = createInputs.default(value, pType, readOnly)

    local x = ui.create("guiTextBox", container, {
      backgroundAlpha = 0.25,
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
      parseInputs[type(value)](property, container)
    end)

    -- TODO TODO TODO TODO 
    -- We need some sort of helper function that'll make 
    -- modals for situations like this:

    if property == "mesh" then
      container.zIndex = 30 -- important because child elements need to be rendered above other properties!
      container.size = container.size + guiCoord(0,0,0,20)


      local presetSelect = ui.create("guiTextBox", container, {
          size = guiCoord(1, -4, 0, 16),
          position = guiCoord(0, 2, 0, 23),
          borderRadius = 3,
          text = "Mesh Presets",
          fontSize = 16,
          align = enums.align.middle,
          backgroundAlpha = 0.75
      }, "primary")

      local meshModal = ui.create("guiFrame", container, {
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
          spawnThread(function ()
              -- Code here...
            wait(.4)
            if not isFocused then
              --still unfocused, lets hide.
              meshModal.visible = false
            end
            pendingHide=false
            
          end)
        end
      end

      presetSelect:onSync("mouseFocused", function ()
        meshModal.visible = true
        isFocused = true
      end)

      meshModal:onSync("mouseFocused", function ()
        isFocused = true
      end)

      presetSelect:onSync("mouseUnfocused", function ()
        isFocused = false
        queueCloseModal()
      end)

      meshModal:onSync("mouseUnfocused", function ()
        isFocused = false
        queueCloseModal()
      end)

      ui.create("guiImage", meshModal, {
        size = guiCoord(0, 24, 0, 24),
        position = guiCoord(0.75, -12, 0, -15),
        handleEvents=false,
        zIndex = 10,
        backgroundAlpha = 0,
        texture = "fa:s-caret-up",
        imageColour = meshModal.backgroundColour
      })

      local curY = 0
      local curX = 0
      for meshName, actualMeshName in pairs(meshShortcuts) do

        local btn = ui.create("guiTextBox", meshModal, {
          size = guiCoord(.5, -10, 0, 18),
          position = guiCoord(curX, 5, 0, curY + 4),
          borderRadius = 3,
          text = meshName,
          fontSize = 16,
          align = enums.align.middle
        }, "primary")

        btn:onSync("mouseFocused", function ()
          isFocused = true
        end)
        btn:onSync("mouseUnfocused", function ()
          isFocused = false
          queueCloseModal()
        end)
        btn:mouseLeftReleased(function ()
          x.text = actualMeshName
          parseInputs[type(value)](property, container)
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
    local container = createInputs.default(value, pType, readOnly)
    container.size = guiCoord(container.size.scaleX, 0, 0, 60)

    local xLabel = ui.create("guiTextBox", container, {
      name = "labelX",
      size = guiCoord(0, 10, 1/3, -1),
      position = guiCoord(0,-10,0,1),
      fontSize = 16,
      textAlpha = 0.6,
      text = "X",
      align = enums.align.topLeft
    }, "backgroundText")
    
    local x = ui.create("guiTextBox", container, {
      backgroundAlpha = 0.25,
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
    themer.registerGui(yLabel, "backgroundText")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(0, 2, 1/3, 0)
    themer.registerGui(y, "primary")

    local zLabel = xLabel:clone()
    zLabel.name = "zLabel"
    zLabel.text = "Z"
    zLabel.parent = container
    zLabel.position = guiCoord(0, -10, 2/3, 1)
    themer.registerGui(yLabel, "backgroundText")

    local z = x:clone()
    z.name = "z"
    z.parent = container
    z.position = guiCoord(0, 2, 2/3, 0)
    themer.registerGui(z, "primary")

    local function handler()
      parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)
    z:textInput(handler)

    return container
  end,

  vector2 = function(instance, property, value)
    local container = createInputs.default(value, pType, readOnly)
    container.size = guiCoord(container.size.scaleX, 0, 0, 40)

    local xLabel = ui.create("guiTextBox", container, {
      name = "labelX",
      size = guiCoord(0, 10, 1/2, -1),
      position = guiCoord(0,-10,0,2),
      fontSize = 16,
      textAlpha = 0.6,
      text = "X",
      align = enums.align.topLeft
    }, "backgroundText")

    local x = ui.create("guiTextBox", container, {
      backgroundAlpha = 0.25,
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
    themer.registerGui(yLabel, "backgroundText")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(0, 2, 1/2, 1)
    themer.registerGui(y, "primary")
    local function handler()
      parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)

    return container
  end,

  quaternion = function(instance, property, value)

    -- maybe quaternions need an Euler editor?

    local container = createInputs.default(value, pType, readOnly)
    container.size = guiCoord(container.size.scaleX, 0, 0, 60)

    local xLabel = ui.create("guiTextBox", container, {
      name = "labelX",
      size = guiCoord(0, 12, 1/3, -1),
      position = guiCoord(0,-10,0,1),
      fontSize = 16,
      textAlpha = 0.6,
      text = "X",
      align = enums.align.topLeft
    }, "backgroundText")

    local x = ui.create("guiTextBox", container, {
      backgroundAlpha = 0.25,
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
    themer.registerGui(yLabel, "backgroundText")

    local y = x:clone()
    y.name = "y"
    y.parent = container
    y.position = guiCoord(0, 2, 1/3, 0)
    themer.registerGui(y, "primary")

    local zLabel = xLabel:clone()
    zLabel.name = "zLabel"
    zLabel.text = "Z"
    zLabel.parent = container
    zLabel.position = guiCoord(0, -10, 2/3, 1)
    themer.registerGui(zLabel, "backgroundText")

    local z = x:clone()
    z.name = "z"
    z.parent = container
    z.position = guiCoord(0, 2, 2/3, 0)
    themer.registerGui(z, "primary")

    --[[local wLabel = xLabel:clone()
    wLabel.name = "wLabel"
    wLabel.text = "W"
    wLabel.parent = container
    wLabel.position = guiCoord(0, -12, 3/4, 2)
    themer.registerGui(wLabel, "backgroundText")

    local w = x:clone()
    w.name = "w"
    w.parent = container
    w.position = guiCoord(0, 2, 3/4, 1)
    themer.registerGui(w, "primary")]]

    local function handler()
      parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)
    z:textInput(handler)
    --w:textInput(handler)

    return container
  end,

  guiCoord = function(instance, property, value)
    local container = createInputs.default(value, pType, readOnly)
    local x = ui.create("guiTextBox", container, {
      backgroundAlpha = 0.25,
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
    themer.registerGui(y, "primary")

    local z = x:clone()
    z.name = "scaleY"
    z.parent = container
    z.position = guiCoord(1/2, 2, 0, 1)
    themer.registerGui(z, "primary")

    local w = x:clone()
    w.name = "offsetY"
    w.parent = container
    w.position = guiCoord(3/4, 2, 0, 1)
    themer.registerGui(w, "primary")

    local function handler()
      parseInputs[type(value)](property, container)
    end
    x:textInput(handler)
    y:textInput(handler)
    z:textInput(handler)
    w:textInput(handler)

    return container
  end,

  colour = function(instance, property, value)
    local container = createInputs.default(value, pType, readOnly)
    container.size = guiCoord(container.size.scaleX, 0, 0, 60)

    local rLabel = ui.create("guiTextBox", container, {
      name = "labelR",
      size = guiCoord(0, 10, 1/3, -1),
      position = guiCoord(0,-10,0,2),
      fontSize = 16,
      textAlpha = 0.6,
      text = "R",
      align = enums.align.topLeft
    }, "backgroundText")

    local x = ui.create("guiTextBox", container, {
      backgroundAlpha = 0.25,
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
    themer.registerGui(gLabel, "backgroundText")

    local g = x:clone()
    g.name = "g"
    g.parent = container
    g.position = guiCoord(0, 2, 1/3, 1)
    themer.registerGui(g, "primary")

    local bLabel = rLabel:clone()
    bLabel.name = "bLabel"
    bLabel.text = "B"
    bLabel.parent = container
    bLabel.position = guiCoord(0, -10, 2/3, 1)
    themer.registerGui(bLabel, "backgroundText")

    local b = x:clone()
    b.name = "b"
    b.parent = container
    b.position = guiCoord(0, 2, 2/3, 1)
    themer.registerGui(b, "primary")

    local function handler()
      parseInputs[type(value)](property, container)
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
      if controller.colourPicker.window.visible and instanceEditing and instanceEditing[property] then
        controller.colourPicker.setColour(instanceEditing[property])
        controller.colourPicker.setCallback(function (c)
          x.text = tostring(c.r)
          g.text = tostring(c.g)
          b.text = tostring(c.b)
          parseInputs[type(value)](property, container)
        end)
      end
    end)

    return container
  end,
}

return createInputs