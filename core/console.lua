--[[
    Copyright 2019 Teverse
    @File console.lua
    @Author(s) Jay
    @Description Will run at teverse startup with a workshop level sandbox.
--]]

local console = {}

console.gui = {}
console.gui.main = engine.construct("guiFrame", workshop.interface, {
  name = "loadingFrame",
  size = guiCoord(0,500,0,400),
  position = guiCoord(0.5,-250,0.5,-200)
})

return console
