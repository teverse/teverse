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

--UI elements
local container = teverse.construct("guiScrollView", {
	scrollbarAlpha = 0;
	scrollbarWidth = 0;
	canvasSize = guiCoord(1, 0, 1, 0);
})

local textBox = teverse.construct("guiTextBox", {
	parent = container;
	size = container.canvasSize + guiCoord(0, container.absoluteSize.x, 0, 0);
	backgroundColour = colour(0.9, 0.9, 0.9);
	textColour = colour(0.5, 0.5, 0.5);
	textEditable = true;
})

--Horizontial scrolling
textBox:on("mouseWheel", function(change)
	local newLocation = container.canvasOffset + vector2(change.y, change.x) * 2
	container.canvasOffset = vector2(
		math.clamp(newLocation.x, 0, container.canvasSize.offset.x),
		math.clamp(newLocation.y, 0, container.canvasSize.offset.y))
end)

--Adjusting canvas to fit the text.
textBox:on("changed", function(propertyName)
	if propertyName == "text" then
		container.canvasSize = guiCoord(1, 0, 1, 0);
		textBox.size = container.canvasSize + guiCoord(0, container.absoluteSize.x, 0, 0)
	end
end)

--Execute the code. If it is "1 + 1", print the result out.
--If the code fails, print it out.
textBox:on("keyDown", function(key)
	if key == "KEY_RETURN" or key == "KEY_KP_ENTER" then
		local function1, errorMessage = loadstring(textBox.text)
		if errorMessage then
			local function2 = loadstring("return "..textBox.text)
			if function2 then
				print(function2())
			else
				print("CONSOLE ERROR: "..errorMessage)
			end
		else
			function1()
		end
		textBox.text = ""
	end
end)

return container