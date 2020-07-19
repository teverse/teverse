local new = function(targetObject, moving)
	local debounce = false
	local onMouseLeftDown = targetObject:on("mouseLeftDown", function(startingMousePosition)
		if debounce then return end
		debounce = true

		local offset = startingMousePosition - targetObject.absolutePosition
		local onMove
		local onRelease

		onMove = teverse.input:on("mouseMoved", function()
			local mousePosition = teverse.input.mousePosition
			moving.position = guiCoord(0, mousePosition.x - offset.x, 0, mousePosition.y - offset.y)
		end)

		onRelease = teverse.input:on("mouseLeftUp", function()
			teverse.disconnect(onMove)
			teverse.disconnect(onRelease)
			debounce = false
		end)
	end)

	return function() teverse.disconnect(onMouseLeftDown) end
end


return new