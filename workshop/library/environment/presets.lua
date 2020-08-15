-- Copyright 2020- Teverse
-- This script constructs (or builds) the baseline (or default) environment
return {
    default = function()
        teverse.scene.simulate = true
        teverse.scene.camera.position = vector3(0, 1, -10)
        teverse.scene.camera.rotation = quaternion.euler(math.rad(25), 0, 0)

        local light = teverse.construct("directionalLight", {
            rotation = quaternion.euler(math.rad(-45), math.rad(20), 0),
            colour = colour(5, 5, 5)
        })

        local base = teverse.construct("block", {
            position = vector3(0, -10, 0),
            scale = vector3(30, 1, 30),
            colour = colour(1, 1, 1)
        })

        -- Load Default PlayerScripts
    end
}