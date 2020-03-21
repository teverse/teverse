-- Copyright 2020 Teverse.com
-- Responsible for managing the aesthetics of different UI elements

local shared = require("tevgit:workshop/controllers/shared.lua")

local currentTheme = nil
local registeredGuis = {}

local themeType = shared.workshop:getSettings("themeType")
customTheme = shared.workshop:getSettings("customTheme")

if themeType == "custom" then
    currentTheme = engine.json:decode(customTheme)
elseif themeType == "black" then
    currentTheme = require("tevgit:workshop/controllers/ui/themes/black.lua")
elseif themeType == "white" then
    currentTheme = require("tevgit:workshop/controllers/ui/themes/white.lua")
elseif themeType == "ow" then
    currentTheme = require("tevgit:workshop/controllers/ui/themes/ow.lua")
else
    currentTheme = require("tevgit:workshop/controllers/ui/themes/default.lua")
    shared.workshop:setSettings("themeType", "default")
end

local function themeriseGui(gui,...)
    -- Grab the gui's style name set in the "registerGui" func
    local styleName = registeredGuis[gui]

    local args = nil
    if #{...} > 0 then
        args = {...}
        args = args[1]
    end 

    -- get the style's properties from the current theme
    local style = currentTheme[styleName]
    if not style then 
        style = {} 
    end

    -- apply the theme's properties to the gui
    for property, value in pairs(style) do
        if gui[property] and gui[property] ~= value then
            gui[property] = value
        end
        if args then
            gui["borderRadius"] = args[1] or 0
        end
    end
end

return {
    types = {
        primary             = "primary",
        primaryVariant      = "primaryVariant",
        primaryText         = "primaryText",
        primaryImage         = "primaryImage",
        
        secondary           = "secondary",
        secondaryVariant    = "secondaryVariant",
        secondaryText       = "secondaryText",
        
        error               = "error",
        errorText           = "errorText",
        
        background          = "background",
        backgroundText      = "backgroundText",        
    },
    
    themeriseGui = themeriseGui,

    registerGui = function(gui, style, ...)
        -- set the gui's style and themerise it.
        registeredGuis[gui] = style
        local args = {...} -- contains overrides
        if args then
            themeriseGui(gui,args)
        elseif not args then
            themeriseGui(gui)
        end
    end,
    
    setTheme = function(theme,...)
        -- change the current theme AND re-themerise all guis
        currentTheme = theme
        args = {...} -- contains overrides
        for gui,v in pairs(registeredGuis) do
            if args then
                themeriseGui(gui,args)
            else
                themeriseGui(gui)
            end
        end
        
        -- Save the theme
        shared.workshop:setSettings("themeType", "custom")
        shared.workshop:setSettings("customTheme", engine.json:encodeWithTypes(currentTheme))
    end,

    resetTheme = function(theme)
        -- change the current theme AND re-themerise all guis
    	currentTheme = require("tevgit:workshop/controllers/ui/themes/default.lua")
    	for gui,v in pairs(registeredGuis) do
    		themeriseGui(gui)
        end
        
        -- Save the theme
        shared.workshop:setSettings("themeType", "default")
        shared.workshop:setSettings("customTheme", null)
    end,

    setThemePreset = function(theme,...)
        -- change the current theme AND re-themerise all guis
        currentTheme = theme
        local args = {...} -- contains overrides
        for gui,v in pairs(registeredGuis) do
            if args then
                themeriseGui(gui,args)
            elseif not args then
                themeriseGui(gui)
            end
        end

        shared.workshop:setSettings("customTheme", null)
    end,

    getTheme = function()
        return currentTheme
    end
}