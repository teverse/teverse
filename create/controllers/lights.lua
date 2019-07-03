-- Teverse doesn't render anything where lights are...
-- This script should render a visible mesh in position of lights to allow the user to see/select them in 3D space.

local controller = {}

controller.lights = {}

controller.registerLight = function(light)
	assert(type(light) == "light")
	for _,v in pairs(controller.lights) do
		if v == light then
			error("already registered")
		end
	end

	local newBlock = engine.construct("block", workspace, {
		doNotSerialise=true,
		name = "_CreateMode_Light_Placeholder",
		size = vector3(0.6, 0.6, 0.6),
		mesh = "tevurl:3d/light.glb",
		emissiveColour = light.diffuseColour*20,
		castsShadows =false,
		position = light.position,
		rotation = light.rotation
	})

	controller.lights[newBlock] = light
	light:destroying(function ()
		controller.lights[newBlock] = nil
		newBlock:destroy()
	end)

	light:changed(function (k,v)
		if newBlock[k] then
			if k == "diffuseColour" then
				newBlock.emissiveColour = light.diffuseColour * 20
			end
		end
	end)
	newBlock:changed(function (k,v)
		if k == "position" and light.position ~= v then
			light.position = v
		elseif k == "rotation" and light.rotation ~= v  then
			light.rotation = v
		end
	end)

end

local function handleChild(c)
	if type(c) == "light" then
		controller.registerLight(c)
	end
end

workspace:childAdded(handleChild)
for _,v in pairs(workspace.children) do
	handleChild(v)
end

return controller