-- Copyright 2020 Teverse.com
-- Used to share variables between scripts

-- shamelessly stolen from http://lua-users.org/wiki/SimpleRound
local function round(n, mult)
    mult = mult or 1
    return math.floor((n + mult/2)/mult) * mult
end

local function calculateVertices (block)
    local vertices = {}
    for x = -1,1,2 do
        for y = -1,1,2 do
            for z = -1,1,2 do
                table.insert(vertices, block.position + block.rotation* (vector3(x,y,z) *block.size/2))
            end
        end
    end
    return vertices
end

local faces = {
	{5, 6, 8, 7},  -- x forward,
	{1, 2, 4, 3},  -- x backward,
	{7, 8, 4, 3},  -- y upward,
	{5, 6, 2, 1},  -- y downward,
	{6, 2, 4, 8},  -- z forward
	{5, 1, 3, 7}  -- z backward
}

return {
    -- Storing workshop is important because sandbox access is restricted.
    workshop = nil,
    controllers = {},
    windows = {},

    round = round,
    roundVector3 = function(v, mult)
        return vector3(round(v.x, mult), round(v.y, mult), round(v.z, mult))
    end,
    roundDp = function (num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end,

    calculateVertices = calculateVertices,

    getCentreOfFace = function (block, face)
        local vertices = calculateVertices(block)
        local avg = vector3(0,0,0)
        for _,i in pairs(faces[face]) do
            avg = avg + vertices[i] 
        end
    
        return avg/4
    end,

    --[[guiLine = function(a, b, parent)
        local avg = (a + b) / 2
        local size = a - b 
        local length = size:length()
        return engine.construct("guiFrame", parent, {
            position = guiCoord(0, avg.x, 0, avg.y),
            size = guiCoord(0, 2, 0, length)
        })
    end,]]

    -- this is set when workshop is set
    -- using the haslocaltevgit api
    developerMode = false
}