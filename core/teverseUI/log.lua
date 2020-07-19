local MAX_LIST = 100

local new = function(properties)
	--[[
		@description
			Creates a new log. The log is displayed through a guiScrollView
		@parameter
			table, [properties]
		@return
			table, interface
	]]
	local viewScroll = teverse.construct("guiScrollView", properties or {})

	local list = {}
	local interface = {}

	interface.add = function(text)
		--[[
			@description
				Add a new log to the list and display.
			@parmeter
				string, text
		]]
		local location = #list + 1
		if (location or 0) > MAX_LIST then
			--Destroy the first one.
			local offset = list[1].absoluteSize.y + 2
			list[1]:destroy()
			table.remove(list, 1)

			--Shift the items back in place.
			for _, item in next, list do
				item.position = item.position - guiCoord(0, 0, 0, offset)
			end
			--Shift the size back correctly
			viewScroll.canvasSize = viewScroll.canvasSize - guiCoord(0, 0, 0, offset)

			location = MAX_LIST
		end

		list[location] = teverse.construct("guiTextBox", {
			parent = viewScroll;
			text = text;
			textWrap = true;
			position = guiCoord(0, 0, 0, viewScroll.canvasSize.offset.y);
			size = guiCoord(1, 0, 1, 0);
		})

		--Shift accordingly
		local textDimensions = list[location].textDimensions
		list[location].size = guiCoord(1, 0, 0, textDimensions.y)
		viewScroll.canvasSize = viewScroll.canvasSize + guiCoord(0, 0, 0, textDimensions.y + 2)
	end

	interface.reload = function()
		--[[
			@description
				Rerenders the log.
		]]
		local offset = 0
		viewScroll.canvasSize = guiCoord(1, 0, 0, 0)

		for _, child in next, list do
			child.position = guiCoord(0, 0, 0, viewScroll.canvasSize.offset.y);
			child.size = guiCoord(1, 0, 1, 0);

			--Shift accordingly
			local textDimensions = child.textDimensions
			child.size = guiCoord(1, 0, 0, textDimensions.y)
			viewScroll.canvasSize = viewScroll.canvasSize + guiCoord(0, 0, 0, textDimensions.y + 2)
			offset = textDimensions.y + offset
		end
	end

	interface.clear = function()
		--[[
			@description
				Clears the logs
		]]
		list = {}
		viewScroll:destroyChildren()
		interface.reload()
	end

	viewScroll:on("changed", function(changed)
		if changed == "canvasSize" then return end
		interface.reload()
	end)
	interface.viewScroll = viewScroll
	return interface
end

return new