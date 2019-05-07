--[[
  (C) 2019 TheFluffyCat / Mooshua (Github / Teverse)
  
  Quicksilver.lua
  "Polish it quicker"

  Small little function that cleans up create calls. 
  Input the instance with a table like property = value.
  It will edit the properties to match the table.


]]
 
function silver(int,tab)
 	for property,value in pairs(tab) do
		local success, err = pcall(function() int[property] = value end)
		if success == false then
			if int[property] == nil then
				error("[ERROR] Quicksilver: Bad Input? Details: "..err,2)
			else
				error("[ERROR] Quicksilver: Unknown Error. Details: "..err,1)
			end
		end
	end
end

return silver
