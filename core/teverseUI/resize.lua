math.clamp = function(x, min, max)
	--[[
		@description
			Clamps a value x with the given arguments.
			LuaJit doesn't have it... cringe!
		@parameters
			number, x
			number, min
			number max
		@return
			number, x
	]]
	return max <= x and max or (x <= min and min or x)
end

math.inBounds = function(x, min, max)
	--[[
	@description
		Checks if a value x with the given arguments.
		LuaJit doesn't have it... cringe!
	@parameters
		number, x
		number, min
		number max
	@return
		boolean, inBounds
	]]
	return x == math.clamp(x, min, max)
end

local directionOfResizeOfAxis = function(object, mousePosition, spacing, axis)
	--[[
		@description
			For a given axis, check the direction we are moving it.
			If we aren't moving it, set it to zero.
		@parameters
			guiObject, object
			vector2, mousePosition
			number, spacing
			string, axis
		@returns
			number, direction
	]]
	if mousePosition[axis] < object.absoluteSize[axis] + object.absolutePosition[axis] + spacing
	and mousePosition[axis] > object.absoluteSize[axis] + object.absolutePosition[axis] then
		return 1;
	elseif mousePosition[axis] < object.absolutePosition[axis]
	and mousePosition[axis] > object.absolutePosition[axis] - spacing then
		return -1
	end

	return 0
end

local directionOfResize = function(object, mousePosition, spacing)
	return vector2(
		directionOfResizeOfAxis(object, mousePosition, spacing, "x"),
		directionOfResizeOfAxis(object, mousePosition, spacing, "y")
	)
end

local sizeAxisBy = function(object, mousePosition, direction, axis)
	local size = mousePosition[axis] - object.absolutePosition[axis]
	if direction == 0 then
		size = object.absoluteSize[axis]
	elseif direction == -1 then
		size = object.absoluteSize[axis] + size * -1
	end
	return size
end

local sizeBy = function(object, mousePosition, direction)
	return guiCoord(
		0,
		sizeAxisBy(object, mousePosition, direction.x, "x"),
		0,
		sizeAxisBy(object, mousePosition, direction.y , "y")
	)
end

local new = function(object, spacing)
	spacing = spacing or 5

	local debounce = false
	local onMouseLeftDown = teverse.input:on("mouseLeftDown", function()
		if debounce then return end
		debounce = true

		local mousePosition = teverse.input.mousePosition
		local direction = directionOfResize(object, mousePosition, spacing)

		local onMouseMoved
		local onMouseLeftUp

		onMouseMoved = teverse.input:on("mouseMoved", function()
			local newMousePosition = teverse.input.mousePosition
			object.size = sizeBy(object, newMousePosition, direction)
			if direction.x == -1 then object.position = guiCoord(0, newMousePosition.x, 0, object.absolutePosition.y) end
			if direction.y == -1 then object.position = guiCoord(0, object.absolutePosition.x, 0, newMousePosition.y) end
		end)
		onMouseLeftUp = teverse.input:on("mouseLeftUp", function()
			teverse.disconnect(onMouseMoved)
			teverse.disconnect(onMouseLeftUp)
			debounce = false
		end)
	end)

	return function() teverse.disconnect(onMouseLeftDown) end
end

return new