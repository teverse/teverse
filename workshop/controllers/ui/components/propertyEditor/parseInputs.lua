-- This module is responsible for converting the gui’s values to the appropriate datatype,
-- AND updating the selection’s properties

local selection = require("tevgit:workshop/controllers/core/selection.lua")

local function callbackInput(property, value)
	local success, message = pcall(function ()
		for _,v in pairs(selection.selection) do
			if v[property] ~= nil then
    			v[property] = value
    		end
		end
	end)

	if not success then print(message) end
end

return {
	block = function (property, gui)

	end,

	boolean = function (property, gui)
		callbackInput(property, gui.input.texture == "fa:s-toggle-on")
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
	end
}