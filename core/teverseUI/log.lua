local MAX_LIST = 100

local new = function(properties)
	local viewScroll = teverse.construct("guiScrollView", properties or {})

	local list = {}
	local interface = {}

	interface.add = function(text)
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

	interface.viewScroll = viewScroll
	return interface
end

return new