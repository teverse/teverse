-- Copyright 2020 Teverse.com
-- Used to share variables between scripts

-- shamelessly stolen from http://lua-users.org/wiki/SimpleRound
local function round(n, mult)
    mult = mult or 1
    return math.floor((n + mult/2)/mult) * mult
end

return {
    -- Storing workshop is important because sandbox access is restricted.
    workshop = nil,
    controllers = {},
    windows = {},

    round = round,
    roundVector3 = function(v, mult)
        return vector3(round(v.x, mult), round(v.y, mult), round(v.z, mult))
    end,

    -- this is set when workshop is set
    -- using the haslocaltevgit api
    developerMode = false
}