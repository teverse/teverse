local selection = require("tevgit:workshop/controllers/core/selection.lua")
local shared = require("tevgit:workshop/controllers/shared.lua")

return {
	camera = require("tevgit:workshop/controllers/environment/camera.lua"),

	createDefaultMap = function ()
		local mainLight = engine.construct("light", workspace, {
			name           = "mainLight",
			position       = vector3(3, 2, 0),
			type           = enums.lightType.directional,
			rotation       = quaternion():setEuler(math.rad(80), 0, 0),
		})	

		local basePlate = engine.construct("block", workspace, {
			name           = "basePlate",
			colour         = colour(0.9, 0.9, 0.9),
			size           = vector3(100, 1, 100),
			position       = vector3(0, -1, 0),
			workshopLocked = true
		})

		engine.construct("block", workspace, {
			name           = "redBlock",
			colour         = colour(1, 0, 0),
			size           = vector3(1, 1, 1),
			position       = vector3(0, 0, 0)
		})	

		engine.construct("block", workspace, {
			name           = "greenBlock",
			colour         = colour(0, 1, 0),
			size           = vector3(1, 1, 1),
			position       = vector3(1, 0, 0),
			mesh	       = "primitive:wedge",
			rotation       = quaternion:setEuler(0, math.rad(90), 0)
		})

		local block = engine.construct("block", workspace, {
			name           = "blueSphere",
			colour         = colour(0, 0, 1),
			size           = vector3(1, 1, 1),
			position       = vector3(0.5, 1, 0),
			mesh  		   = "primitive:sphere",
			roughness 	   = 0.5,
			metalness      = 0.8
		})	
	end,

	setupEnvironment = function ()
		engine.graphics.clearColour = colour:fromRGB(56,56,66)
		engine.graphics.ambientColour = colour(0.3, 0.3, 0.3)
	end,

	createPBRDebugSpheres = function ()
		for r = 0, 1, 0.1 do
			for m = 0, 1, 0.1 do
				local b = engine.construct("block", workspace, {
					size = vector3(0.8, 0.8, 0.8),
					position = vector3((r*10)-5, 3, (m*10)-5),
					mesh = "primitive:sphere",
					roughness = r,
					metalness = m
				})
			end
		end

		for r = 0, 1, 0.1 do
			for m = 0, 1, 0.1 do
				local b = engine.construct("block", workspace, {
					size = vector3(10, 1, 10),
					position = vector3((r*100)-5, 1, (m*100)-5),
					roughness = r,
					metalness = m
				})
			end
		end

		local cubes = {}
		for r = 0, 1, 0.1 do
			for m = 0, 1, 0.1 do
				table.insert(cubes, engine.construct("block", workspace, {
					size = vector3(0.5, 0.5, 0.5),
					position = vector3((r*10)+10, 3, (m*10)-5),
					mesh = "tevurl:3d/duck.glb",
					roughness = r,
					metalness = m,
					colour = colour(1,1,0)
				}))
			end
		end

		spawnThread(function()
			while wait() do
				for _,v in pairs(cubes) do
					v.rotation = v.rotation * quaternion:setEuler(0, math.rad(v.roughness*3), math.rad(v.metalness*3))
				end
			end
		end)
	end
}
