-- Copyright 2019 Teverse.com
-- Used to share variables between scripts

return {
    -- Storing workshop is important because sandbox access is restricted.
    workshop = nil,
    controllers = {},
    windows = {},

    -- this is set when workshop is set
    -- using the haslocaltevgit api
    developerMode = false
}