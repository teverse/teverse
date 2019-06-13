local controller = {}

local toolSettings = require("tevgit:create/controllers/toolSettings.lua")

function controller.roundToMultiple(number, multiple)
	if multiple == 0 then 
		return number 
	end
	
	return ((number % multiple) > multiple/2) and number + multiple - number%multiple or number - number%multiple
end

function controller.roundVectorToMultiple(vec, multiple)
	return vector3(controller.roundToMultiple(vec.x, multiple),
				   controller.roundToMultiple(vec.y, multiple),
				   controller.roundToMultiple(vec.z, multiple))
end

function controller.roundVectorWithToolSettings(vec)
	local multiple = toolSettings.gridStep
	vec.x = toolSettings.axis[1][2] and controller.roundToMultiple(vec.x, multiple) or vec.x
	vec.y = toolSettings.axis[2][2] and controller.roundToMultiple(vec.y, multiple) or vec.y
	vec.z = toolSettings.axis[3][2] and controller.roundToMultiple(vec.z, multiple) or vec.z
	return vec
end

return controller