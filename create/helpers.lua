local controller = {}

function controller.roundToMultiple(number, multiple)
	if multiple == 0 then 
		return number 
	end
	
	return ((number % multiple) > multiple/2) and number + multiple - number%multiple or number - number%multiple
end

function controller.calculateVertices(block)
	local vertices = {}
	for x = -1,1,2 do
		for y = -1,1,2 do
			for z = -1,1,2 do
				table.insert(vertices, block.position + block.rotation* (vector3(x,y,z) *block.size/2))
			end
		end
	end
	return vertices
end

-- these numbers are vertices indexes calculated in above function
local faces = {
	{5, 6, 8, 7},  -- x forward,
	{1, 2, 4, 3},  -- x backward,
	{7, 8, 4, 3},  -- y upward,
	{5, 6, 2, 1},  -- y downward,
	{6, 2, 4, 8},  -- z forward
	{5, 1, 3, 7}  -- z backward
}

function controller.getCentreOfFace(block, face)
	local vertices = controller.calculateVertices(block)
	local avg = vector3(0,0,0)
	for _,i in pairs(faces[face]) do
		avg = avg + vertices[i] 
	end

	return avg/4
end

function controller.vector3ToGuiCoord(vec)
	local inFrontOfCamera, screenPos = workspace.camera:worldToScreen(vec)
	if inFrontOfCamera then
		return guiCoord(0, screenPos.x, 0, screenPos.y)
	else
		return guiCoord(-1,0,0,0)
	end
end

function controller.roundVectorToMultiple(vec, multiple)
	return vector3(controller.roundToMultiple(vec.x, multiple),
				   controller.roundToMultiple(vec.y, multiple),
				   controller.roundToMultiple(vec.z, multiple))
end

function controller.roundVectorWithToolSettings(vec)
	local toolSettings = require("tevgit:create/controllers/toolSettings.lua")
	local multiple = toolSettings.gridStep
	vec.x = toolSettings.axis[1][2] and controller.roundToMultiple(vec.x, multiple) or vec.x
	vec.y = toolSettings.axis[2][2] and controller.roundToMultiple(vec.y, multiple) or vec.y
	vec.z = toolSettings.axis[3][2] and controller.roundToMultiple(vec.z, multiple) or vec.z
	return vec
end

--Calculate median of vector
--modified from http://lua-users.org/wiki/SimpleStats
function controller.median( t, component )
  local temp={}

  for k,v in pairs(t) do
  	if v and v.position then
    	table.insert(temp, v.position[component])
    end
  end

  table.sort( temp )

  if math.fmod(#temp,2) == 0 then
    return ( temp[#temp/2] + temp[(#temp/2)+1] ) / 2
  else
    return temp[math.ceil(#temp/2)]
  end
end


return controller