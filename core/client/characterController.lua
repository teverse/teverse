--[[
    Copyright 2019 Teverse
    @File core/client/characterController.lua
    @Author(s) Jay
--]]

local controller = {}

controller.speed = 100

controller.character = engine.construct("block", workspace, {
	size = vector3(2,3,1),
	colour = colour(math.random(),math.random(),math.random()),
	position = vector3(0,10,0),
	static = false,
	velocity = vector3(0,10,0)
})

controller.keyBinds = {
	w = vector3(0,0,1),
	s = vector3(0,0,-1),
	a = vector3(1,0,0),
	d = vector3(-1,0,0)
}

controller.update = function()
	local totalForce = vector3()
	local moved = false

	for key, force in pairs(controller.keyBinds) do
		if engine.input:isKeyDown(enums.key[key]) then
			moved=true
			totalForce = totalForce + force
		end
	end
	if moved then
		controller.character:applyForce(totalForce * controller.speed)
	end
end

--engine.graphics:frameDrawn(controller.update)

return controller