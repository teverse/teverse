print("Hello Server!")

-- The game this is intended for has default scripts disabled, 
-- however: we want to load some core server code anyway

require("tevgit:core/server/debug.lua")
require("tevgit:core/server/chat.lua")

for _,v in pairs(workspace.children) do
    if v.className == "block" then
        v:destroy()
    end
end

local minable = {}

local function setSpaceUsed(x, y, z, value)
    if not minable[x] then 
        minable[x] = {}
    end

    if not minable[x][y] then 
        minable[x][y] = {}
    end

    minable[x][y][z] = value
end

local function fillSpace(x, y, z)
    local block = engine.construct("block", workspace, {
        name        = "minable",
        position    = vector3(x * 4, y * 4, z * 4),
        size        = vector3(4, 4, 4),
        colour      = colour:random(),
        static      = true
    })

    setSpaceUsed(x, y, z, block)

    return block
end

local function isSpaceUsed(x, y, z)
    if y > 0 then
        return true
    elseif not minable[x] or not minable[x][y] or not minable[x][y][z] then
        return false
    else
        return true
    end
end

for x = -5, 5 do
    for z = -5, 5 do
        fillSpace(x, 0, z)
    end
end

-- There's not much validation here...
engine.networking:bind( "mineBlock", function( client, x, y, z )
	if type(x) == "number" and type(y) == "number" and type(z) == "number" and isSpaceUsed(x, y, z) then
        local block = minable[x][y][z]
        block:destroy()

        setSpaceUsed(x, y, z, true)

        if not isSpaceUsed(x, y - 1, z) then
            fillSpace(x, y - 1, z)
        end

        if not isSpaceUsed(x, y + 1, z) then
            fillSpace(x, y + 1, z)
        end

        if not isSpaceUsed(x - 1, y, z) then
            fillSpace(x - 1, y, z)
        end

        if not isSpaceUsed(x + 1, y, z) then
            fillSpace(x + 1, y, z)
        end

        if not isSpaceUsed(x, y, z - 1) then
            fillSpace(x, y, z - 1)
        end
        
        if not isSpaceUsed(x, y, z + 1) then
            fillSpace(x, y, z + 1)
        end
	end
end)