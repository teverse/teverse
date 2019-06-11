local controller = {}

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

return controller