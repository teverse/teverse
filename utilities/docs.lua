--[[
    This contents of this script is used in our
    API dumps.
]]

local docs = {}
local function addDocs(class, d)
    docs[class] = d
end

local function property(desc)
    if not desc then desc = "No description was set" end
    return { description = desc }
end

local function method(desc, params, returns)
    if not desc then desc = "No description was set" end
    return { description = desc, parameters = params, returns = returns }
end

local function event(desc, params)
    if not desc then desc = "No description was set" end
    return { description = desc, parameters = params}
end

--------------- Docs Begin ---------------

addDocs("graphics", {
  properties = {
      ambientColour = property("How bright the scene is"), 
      className = property("undefined"), 
      name = property("undefined"), 
      clearColour = property("The background colour of the scene"), 
  },
  methods = {
      reloadShaders = method("Reloads the shaders of the scene and recompiles if possible.", nil, nil), 
  },
  events = {
      frameDrawn = event("undefined", {['timeSinceLast'] = 'number'}), 
  },
})

addDocs("json", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
      decode = method("undefined", {['json'] = 'string'}, {'table'}), 
      encodeWithTypes = method("undefined", {['table'] = 'table'}, {'string'}), 
      encode = method("undefined", {['table'] = 'table'}, {'stripe'}), 
  },
  events = {
  },
})

addDocs("networking", {
  properties = {
      className = property("undefined"), 
      ping = property("The last ping result"), 
      connectionStatus = property("Current status of the connection"), 
      me = property("false if not connected, once connected this is set to the current user object"), 
      name = property("undefined"), 
      serverId = property("the id of the connected server"), 
  },
  methods = {
      toServer = method("Sends a message to the connected server", {['...'] = '...', ['eventName'] = 'string'}, nil), 
      bind = method("binds the provide callback to the eventname. Returns a table with a disconnect method.", {['callback'] = 'function', ['eventName'] = 'string'}, {'table'}), 
      toAllClients = method("Broadcasts a message to all connected clients (server only)", {['...'] = '...', ['eventName'] = 'string'}, nil), 
      toClient = method("Broadcasts a message to the connected client (server only)", {['...'] = '...', ['client'] = 'client', ['eventName'] = 'string'}, nil), 
  },
  events = {
      connected = event("undefined", {}), 
      pingUpdate = event("undefined", {}), 
      disconnected = event("undefined", {['ping'] = 'number'}), 
  },
})

addDocs("client", {
  properties = {
      className = property("undefined"), 
      id = property("the client's unique identifer"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("clients", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
      getClientFromId = method("undefined", {['id'] = 'string'}, {'client'}), 
  },
  events = {
      clientDisconnected = event("undefined", {['client'] = 'client'}), 
      clientConnected = event("undefined", {['client'] = 'client'}), 
  },
})

addDocs("physics", {
  properties = {
      running = property("wherever or not the simulation is running"), 
      className = property("undefined"), 
      name = property("undefined"), 
      gravity = property("the rate of gravity, defaults to 0, -9.8, 0-"), 
  },
  methods = {
      getContacts = method("unimplemented", {['block'] = 'block'}, {'nil'}), 
      resume = method("resumes physics and sets running to true", nil, nil), 
      rayTestScreenAllHits = method("runs a ray test query with our physics engine from the absolute coordinates x,y", {['y'] = 'number', ['exclusion'] = 'table'}, {'table'}), 
      rayTestAllHits = method("runs a ray test query with our physics engine between the start and end points provided", {['end'] = 'vector3', ['exclusion'] = 'table'}, {'table'}), 
      pause = method("stops the physics engine and sets running to false", nil, nil), 
      rayTestClosest = method("runs a ray test query with our physics engine between the start and end points provided", {['end'] = 'vector3'}, {'table'}), 
      rayTestScreen = method("runs a ray test query with our physics engine from the x,y screen position", {['y'] = 'number'}, {'table'}), 
  },
  events = {
  },
})

addDocs("debug", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
      locals = method("undefined", nil, nil), 
      getfenv = method("undefined", nil, nil), 
      upvalues = method("undefined", nil, nil), 
  },
  events = {
      output = event("undefined", {['output'] = 'string'}), 
  },
})

addDocs("http", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
      post = method("Is callback is nil, this function yields and returns the httpResult", {['callback'] = 'function', ['body'] = 'string'}, {'httpResult'}), 
      request = method("Is callback is nil, this function yields and returns the httpResult. ", {['callback'] = 'function', ['body'] = 'string', ['headers'] = 'table'}, {'httpResult'}), 
      urlEncode = method("url encodes the string", {['url'] = 'string'}, {'string'}), 
      urlDecode = method("decodes the url", {['url'] = 'string'}, {'string'}), 
      get = method("Is callback is nil, this function yields and returns the httpResult", {['callback'] = 'function', ['url'] = 'string'}, {'httpResult'}), 
  },
  events = {
  },
})

addDocs("input", {
  properties = {
      screenSize = property("The size of the screen"), 
      className = property("undefined"), 
      cursorTexture = property("the cursor's texture"), 
      mousePosition = property("The position of the mouse"), 
      mouseFocusedGui = property("The gui element currently capturing the mouse input"), 
      name = property("undefined"), 
      keyFocusedGui = property("undefined"), 
  },
  methods = {
      isKeyDown = method("returns if the key is pressed", {['key'] = 'enums.key'}, {'bool'}), 
      isMouseButtonDown = method("returns if the mouse is down", {['mb'] = 'enums.mouseButton'}, {'boo'}), 
  },
  events = {
      mouseLeftPressed = event("input event", {['inputObject'] = 'inputObject'}), 
      keyReleased = event("input event", {['inputObject'] = 'inputObject'}), 
      keyPressed = event("input event", {['inputObject'] = 'inputObject'}), 
      mouseMiddleReleased = event("input event", {['inputObject'] = 'inputObject'}), 
      mouseMiddlePressed = event("input event", {['inputObject'] = 'inputObject'}), 
      mouseScrolled = event("input event", {['inputObject'] = 'inputObject'}), 
      mouseRightReleased = event("input event", {['inputObject'] = 'inputObject'}), 
      mouseMoved = event("input event", {['inputObject'] = 'inputObject'}), 
      mouseRightPressed = event("input event", {['inputObject'] = 'inputObject'}), 
      mouseLeftReleased = event("input event", {['inputObject'] = 'inputObject'}), 
  },
})

addDocs("folder", {
  properties = {
      className = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("assetsFolder", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("luaFolder", {
  properties = {
      className = property("undefined"), 
      name = property("undefined"), 
      disableDefaultLoaders = property("If true, default scripts are not loaded when the game is in play mode"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("script", {
  properties = {
      className = property("undefined"), 
      source = property("the script's source"), 
      id = property("undefined"), 
      autoRun = property("if true, teverse runs this automatically"), 
      ran = property("true after the script starts"), 
  },
  methods = {
      run = method("runs the script", nil, nil), 
      editExternal = method("opens the script in the user's default text editor", nil, nil), 
  },
  events = {
  },
})

addDocs("luaClientFolder", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("luaServerFolder", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("luaSharedFolder", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("block", {
  properties = {
      renderQueue = property("not implemented"), 
      linearFactor = property("Restricts the linear movement in the physics engine. A value of (1,1,1) allows the object to move in all directions whereas (0,1,0) means the object can only move up and down on the y axis."), 
      doNotSerialise = property("The built in game serialiser will not serialise objects with this set as true."), 
      friction = property("Physics"), 
      linearDamping = property("Physics"), 
      metalness = property("undefined"), 
      restitution = property("Physics"), 
      size = property("undefined"), 
      workshopLocked = property("Solely used in workshop"), 
      meshScale = property("This is the value Teverse has had to scale the loaded mesh down in order to fit it in a 1x1x1 bounding box"), 
      mesh = property("The file that teverse will use to load a 3d model, using [[resource locators]]."), 
      roughness = property("undefined"), 
      emissiveness = property("undefined"), 
      position = property("Location of the object in 3D space"), 
      physics = property("When true, things like raycasting may not work correctly for this object"), 
      colour = property("undefined"), 
      angularFactor = property("Physics"), 
      networkedId = property("undefined"), 
      static = property("When true, this object will not move as it will become unaffected by forces including gravity."), 
      linearVelocity = property("Physics"), 
      className = property("undefined"), 
      rotation = property("undefined"), 
      castsShadows = property("undefined"), 
      angularDamping = property("Physics"), 
      wireframe = property("undefined"), 
      angularVelocity = property("Physics"), 
      opacity = property("A value of 1 indicates this object is not transparent."), 
  },
  methods = {
      applyImpulseAtPosition = method("Applies an impulse force at a relative position to this object", {['position'] = 'vector3'}, nil), 
      applyImpulse = method("Applies an impulse force to this object", {['impulse'] = 'vector3'}, nil), 
      applyForce = method("Applies a force to this object", {['force'] = 'vector3'}, nil), 
      applyTorque = method("Applies a force to this object", {['torque'] = 'vector3'}, nil), 
      applyForceAtPosition = method("Applies a force at a relative position to this object", {['force'] = 'vector3'}, nil), 
      lookAt = method("Changes the objects rotation so that it is looking towards the provided position.", {['position'] = 'vector3'}, nil), 
      applyTorqueImpulse = method("Applies a force to this object", {['torqueImpulse'] = 'vector3'}, nil), 
  },
  events = {
      mouseLeftPressed = event("undefined", {}), 
      collisionStarted = event("undefined", {}), 
      mouseLeftReleased = event("undefined", {}), 
      mouseRightPressed = event("undefined", {}), 
      mouseRightReleased = event("undefined", {}), 
      collisionEnded = event("undefined", {}), 
      mouseMiddleReleased = event("undefined", {}), 
      mouseMiddlePressed = event("undefined", {}), 
  },
})

addDocs("workspace", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("camera", {
  properties = {
      fov = property("undefined"), 
      position = property("undefined"), 
      className = property("undefined"), 
      name = property("undefined"), 
      rotation = property("undefined"), 
  },
  methods = {
      screenToWorld = method("undefined", nil, nil), 
      worldToScreen = method("Converts a 3d cooridinate into screenspace. Returns a bool indicating if the point is infront of the camera, returns a vector2 with the screenspace coordinates,", {['position'] = 'vector3'}, {'boolean', 'vector2', 'number'}), 
      lookAt = method("Changes the objects rotation so that it is looking towards the provided position.", {['position'] = 'vector3'}, nil), 
  },
  events = {
  },
})

addDocs("compoundGroup", {
  properties = {
      rotation = property("undefined"), 
      position = property("undefined"), 
      linearFactor = property("undefined"), 
      linearVelocity = property("undefined"), 
      friction = property("undefined"), 
      className = property("undefined"), 
      linearDamping = property("undefined"), 
      static = property("undefined"), 
      restitution = property("undefined"), 
      angularDamping = property("undefined"), 
      angularVelocity = property("undefined"), 
      name = property("undefined"), 
      angularFactor = property("undefined"), 
  },
  methods = {
      applyImpulse = method("undefined", nil, nil), 
      applyTorque = method("undefined", nil, nil), 
      applyForce = method("undefined", nil, nil), 
      applyForceAtPosition = method("undefined", nil, nil), 
      applyImpulseAtPosition = method("undefined", nil, nil), 
      applyTorqueImpulse = method("undefined", nil, nil), 
  },
  events = {
      mouseLeftPressed = event("undefined", {}), 
      collisionStarted = event("undefined", {}), 
      mouseLeftReleased = event("undefined", {}), 
      mouseRightPressed = event("undefined", {}), 
      mouseRightReleased = event("undefined", {}), 
      collisionEnded = event("undefined", {}), 
      mouseMiddleReleased = event("undefined", {}), 
      mouseMiddlePressed = event("undefined", {}), 
  },
})

addDocs("light", {
  properties = {
      rotation = property("undefined"), 
      shadowNearClip = property("undefined"), 
      power = property("undefined"), 
      specularColour = property("undefined"), 
      radius = property("undefined"), 
      shadowFarClip = property("undefined"), 
      lumThreshold = property("undefined"), 
      className = property("undefined"), 
      position = property("undefined"), 
      type = property("undefined"), 
      shadows = property("undefined"), 
      diffuseColour = property("undefined"), 
      shadowFarDistance = property("undefined"), 
      falloff = property("undefined"), 
  },
  methods = {
      lookAt = method("undefined", nil, nil), 
  },
  events = {
  },
})

addDocs("grid", {
  properties = {
      step = property("undefined"), 
      rotation = property("undefined"), 
      size = property("undefined"), 
      colour = property("undefined"), 
      className = property("undefined"), 
      position = property("undefined"), 
  },
  methods = {
      lookAt = method("undefined", nil, nil), 
  },
  events = {
  },
})

addDocs("line", {
  properties = {
      colour = property("undefined"), 
      positionB = property("undefined"), 
      className = property("undefined"), 
      positionA = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("audioEmitter", {
  properties = {
      className = property("undefined"), 
      position = property("Location of the sound in 3D space"), 
      pitch = property("undefined"), 
      audioFile = property("The file that teverse will use to load sound, using [[resource locators]]."), 
      gain = property("undefined"), 
      loop = property("undefined"), 
  },
  methods = {
      play = method("play the loaded audio file", nil, nil), 
  },
  events = {
  },
})

addDocs("sounds", {
  properties = {
      name = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
      play = method("undefined", nil, nil), 
  },
  events = {
  },
})

addDocs("guiFrame", {
  properties = {
      className = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("guiFrameMultiColour", {
  properties = {
      topLeftColour = property("undefined"), 
      topRightColour = property("undefined"), 
      topRightAlpha = property("undefined"), 
      bottomLeftColour = property("undefined"), 
      className = property("undefined"), 
      bottomLeftAlpha = property("undefined"), 
      topLeftAlpha = property("undefined"), 
      bottomRightColour = property("undefined"), 
      bottomRightAlpha = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("guiScrollView", {
  properties = {
      viewOffset = property("undefined"), 
      scrollBarWidth = property("undefined"), 
      canvasSize = property("undefined"), 
      className = property("undefined"), 
      scrollBarColour = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("interface", {
  properties = {
      className = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("guiTextBox", {
  properties = {
      readOnly = property("undefined"), 
      multiline = property("undefined"), 
      className = property("undefined"), 
  },
  methods = {
      setAsPasswordInput = method("undefined", nil, nil), 
      focus = method("undefined", nil, nil), 
      setTextColour = method("undefined", nil, nil), 
      setText = method("undefined", nil, nil), 
  },
  events = {
      textInput = event("undefined", {}), 
  },
})

addDocs("guiButton", {
  properties = {
      className = property("undefined"), 
      hoverCursor = property("undefined"), 
      selected = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("guiTextBase", {
  properties = {
      fontSize = property("undefined"), 
      className = property("undefined"), 
      align = property("undefined"), 
      textColour = property("undefined"), 
      wrap = property("undefined"), 
      textAlpha = property("undefined"), 
      fontFile = property("undefined"), 
      text = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("guiImage", {
  properties = {
      imageAlpha = property("undefined"), 
      className = property("undefined"), 
      uvB = property("undefined"), 
      imageColour = property("undefined"), 
      uvA = property("undefined"), 
      texture = property("undefined"), 
  },
  methods = {
  },
  events = {
  },
})

addDocs("guiBase", {
  properties = {
      zIndex = property("undefined"), 
      rotation = property("undefined"), 
      position = property("undefined"), 
      visible = property("undefined"), 
      cropChildren = property("undefined"), 
      handleEvents = property("undefined"), 
      borderAlpha = property("undefined"), 
      className = property("undefined"), 
      borderColour = property("undefined"), 
      hoverCursor = property("undefined"), 
      borderRadius = property("undefined"), 
      backgroundColour = property("undefined"), 
      backgroundAlpha = property("undefined"), 
      size = property("undefined"), 
      borderWidth = property("undefined"), 
  },
  methods = {
      bindSizeBreakpoint = method("", {['breakpoint'] = 'enums.sizeBreakpoint', ['properties'] = 'table'}, nil), 
  },
  events = {
      keyUnfocused = event("undefined", {}), 
      mouseFocused = event("undefined", {}), 
      keyReleased = event("undefined", {}), 
      mouseRightDragged = event("undefined", {}), 
      mouseLeftDragged = event("undefined", {}), 
      keyFocused = event("undefined", {}), 
      mouseMiddleReleased = event("undefined", {}), 
      mouseMiddlePressed = event("undefined", {}), 
      mouseMiddleDragged = event("undefined", {}), 
      mouseScrolled = event("undefined", {}), 
      mouseRightReleased = event("undefined", {}), 
      keyPressed = event("undefined", {}), 
      mouseRightPressed = event("undefined", {}), 
      mouseLeftReleased = event("undefined", {}), 
      mouseUnfocused = event("undefined", {}), 
      mouseLeftPressed = event("undefined", {}), 
  },
})

addDocs("tween", {
  properties = {
      license = property("undefined"), 
      className = property("undefined"), 
      name = property("undefined"), 
  },
  methods = {
      begin = method("undefined", nil, nil), 
      create = method("undefined", nil, nil), 
  },
  events = {
  },
})

addDocs("workshop", {
  properties = {
      className = property("undefined"), 
      interface = property("undefined"), 
      gameCloudId = property("undefined"), 
      name = property("undefined"), 
      gameFilePath = property("undefined"), 
  },
  methods = {
      disconnectGame = method("undefined", nil, nil), 
      joinGame = method("undefined", nil, nil), 
      hasLocalTevGit = method("undefined", nil, nil), 
      reloadCreate = method("undefined", nil, nil), 
      setTevGit = method("undefined", nil, nil), 
      saveGame = method("undefined", nil, nil), 
      setSettings = method("undefined", nil, nil), 
      setSoundDebug = method("undefined", nil, nil), 
      openFileDialogue = method("undefined", nil, nil), 
      newGame = method("undefined", nil, nil), 
      remoteTestServer = method("undefined", nil, nil), 
      reloadShaders = method("undefined", nil, nil), 
      clearGame = method("undefined", nil, nil), 
      apiDump = method("undefined", nil, nil), 
      getEventsOfObject = method("undefined", nil, nil), 
      isHomeRunning = method("undefined", nil, nil), 
      saveGameAsDialogue = method("undefined", nil, nil), 
      home = method("undefined", nil, nil), 
      getMembersOfInstance = method("undefined", nil, nil), 
      loadString = method("undefined", nil, nil), 
      getMembersOfObject = method("undefined", nil, nil), 
      publishDialogue = method("undefined", nil, nil), 
      setPhysicsDebug = method("undefined", nil, nil), 
      getSettings = method("undefined", nil, nil), 
  },
  events = {
      published = event("undefined", {}), 
  },
})

addDocs("baseClass", {
  properties = {
      name = property("A none unique identifier"), 
      className = property("The name of the object's class"), 
  },
  methods = {
      getDescendants = method("Returns a table of all descended objects", nil, {'table'}), 
      isContainer = method("Returns true if this object can contain other objects.", nil, {'boolean'}), 
      isA = method("Returns true if this object is derived from the className given.", {['className'] = 'string'}, {'boolean'}), 
      destroy = method("Locks the object before removing it from the hierarchy. Children will also be destroyed.", nil, nil), 
      getFullName = method("Returns a string including ancestor names", nil, {'string'}), 
      constructor = method("undefined", nil, nil), 
      destroyAllChildren = method("Invokes the destroy method on each child of this instance.", nil, nil), 
      hasChild = method("Returns true if this object has a child with the name given", {['name'] = 'string'}, {'boolean'}), 
      isDescendantOf = method("Returns true if this object is a descendant of the ancestor object given", {['ancestor'] = 'baseClass'}, {'boolean'}), 
      describe = method("", nil, {'string'}), 
      clone = method("Creates and returns a copy of this object", nil, {'variant'}), 
  },
  events = {
      changed = event("Fired when a property changes", {['propertyName'] = 'string', ['newValue'] = 'variant', ['oldValue'] = 'variant'}), 
      childAdded = event("Fired when a child is added", {['child'] = 'variant'}), 
      childRemoved = event("Fired when a child is removed", {['child'] = 'variant'}), 
      destroying = event("Fired just before an object is destroyed.", {}), 
  },
})

addDocs("engine", {
  properties = {
      input = property("A readonly property"), 
      guiImage = property("The default constructor for guiImage"), 
      audioEmitter = property("The default constructor for audioEmitter"), 
      guiFrameMultiColour = property("The default constructor for guiFrameMultiColour"), 
      compoundGroup = property("The default constructor for compoundGroup"), 
      sounds = property("A singleton used for playing global sounds."), 
      guiButton = property("The default constructor for guiButton"), 
      block = property("The default constructor for block"), 
      graphics = property("A singleton for graphics"), 
      guiScrollView = property("The default constructor for guiScrollView"), 
      platform = property("the current platform running Teverse"), 
      guiFrame = property("The default constructor for guiFrame"), 
      script = property("The default constructor for script"), 
      folder = property("The default constructor for folder"), 
      assets = property("The assets singleton"), 
      networking = property("The networking singleto"), 
      physics = property("The physics singleton"), 
      debug = property("The debug singleton"), 
      guiTextBox = property("The default constructor for guiTextBox"), 
      json = property("The JSON singleton"), 
      workspace = property("The workspace singleton"), 
      className = property("undefined"), 
      light = property("The default constructor for light"), 
      grid = property("The default constructor for grid"), 
      interface = property("The default interface singleto"), 
      tween = property("The tween singleton"), 
      name = property("undefined"), 
      line = property("The default constructor for line"), 
  },
  methods = {
      openUrl = method("opens the default web browser", {['url'] = 'string'}, nil), 
      construct = method("a generic constructor", {['parent'] = 'variant', ['properties'] = 'table', ['className'] = 'string'}, {'variant'}), 
      isAuthenticated = method("undefined", nil, nil), 
  },
  events = {
      stepped = event("undefined", {}), 
  },
})



return docs