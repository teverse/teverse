-- This is used to debug networked physics.

local blocks = {}

for x = -10, 10, 1 do
	for z = -10, 10, 1 do
		table.insert(blocks, engine.construct("block", workspace,{
					size = vector3(0.5, 0.5, 0.5),
					position = vector3(x, 10, z),
					colour = colour:random(),
					static = false,
					mesh = "primitive:sphere"
				}))
	end
end

while wait(5) do
	for _,v in pairs(blocks) do
		v:applyImpulse(0,1,0)
		wait()
	end
end

--[[
local blocks = {}

while wait() do
	for x = 0,3,0.5 do
		for z = 0,3,0.5 do
			for y = 0,3,0.5 do
				table.insert(blocks, engine.construct("block", workspace,{
					size = vector3(0.5, 0.5, 0.5),
					position = vector3(x,y,z),
					colour = colour:random(),
					static = false
				}))
			end
		end
	end

	for i = 1, 10 do
		local projectile = engine.construct("block", workspace, {
			size = vector3(1, 1, 1),
			position = vector3(0, 5, 0),
			mesh = "primitive:sphere"
		})
		
		wait(1)
		projectile.static = false
		projectile:applyForce(0, -20, 0)
		wait(4)
	end

	for _,v in pairs(blocks) do
		v:destroy()
	end

	blocks = {}
end
]]