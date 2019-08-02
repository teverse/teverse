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
		size = vector3(0.3, 0.3, 0.3),
		mesh = "tevurl:3d/light.glb",
		emissiveColour = light.diffuseColour*20,
		castsShadows =false,
		position = light.position,
		rotation = light.rotation
	})

	local destroyed = false

	controller.lights[newBlock] = light
	light:destroying(function ()
		if not destroyed then
			destroyed = true
			controller.lights[newBlock] = nil
			newBlock:destroy()
		end
	end)

	--delay updates to block to lower risk of loop
	local lastUpdate = nil
	light:changed(function (k,v)
		if not lastUpdate and newBlock[k] then
			lastUpdate = os.time()
			repeat wait(.1) until os.time() - lastUpdate > 0.6
			
			newBlock.emissiveColour = (light.diffuseColour * 20):max(colour(0.1,0.1,0.1))

			if newBlock.position ~= light.position then
				newBlock.position = light.position
			elseif newBlock.rotation ~= light.rotation  then
				newBlock.rotation = light.rotation
			end
			lastUpdate = nil
		elseif lastUpdate then
			lastUpdate = os.time()
		end
	end)

	newBlock:changed(function (k,v)
		if k == "position" and light.position ~= v then
			light.position = v
		elseif k == "rotation" and light.rotation ~= v  then
			light.rotation = v
		end
	end)

	newBlock:destroying(function ()
		if not destroyed then
			destroyed = true
			light:destroy()
		end
	end)

end

local function handleChild(c)
	if type(c) == "light" then
		print("Registering new light", c)
		controller.registerLight(c)
	end
end

workspace:childAdded(handleChild)
for _,v in pairs(workspace.children) do
	handleChild(v)
end

return controller