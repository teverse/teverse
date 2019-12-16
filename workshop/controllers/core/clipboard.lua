local keybinder = require("tevgit:workshop/controllers/core/keybinder.lua")
local history = require("tevgit:workshop/controllers/core/history.lua")
local selection = require("tevgit:workshop/controllers/core/selection.lua")

local clipboard = {}

keybinder:bind({
    name = "copy",
    key = enums.key.c,
    priorKey = enums.key.leftCtrl,
	action = function()
		clipboard = selection.selection
	end
})

keybinder:bind({
    name = "paste",
    key = enums.key.v,
    priorKey = enums.key.leftCtrl,
	action = function()
        history.beginAction(workspace, "Paste")

        local bounds = aabb()
        if #clipboard > 0 then
            bounds.min = clipboard[1].position
            bounds.max = clipboard[1].position
        end

        -- translates the pasted objects by:
        local offset = vector3(0, 0, 0)
        -- pass the clipboard to calculate bounds
        for _,v in pairs(clipboard) do
            if type(v.position) == "vector3" and type(v.size) == "vector3" then
                bounds:expand(v.position + (v.size / 2))
                bounds:expand(v.position - (v.size / 2))
            end
        end
        offset = vector3(0, bounds.max.y - bounds.min.y, 0)

        local centre = bounds:getCentre()

        local clones = {}
        for _,v in pairs(clipboard) do
            if v and v.alive then
                local new = v:clone()
                new.parent = workspace
                if type(new.position) == "vector3" then
                    new.position = new.position + offset
                end
                table.insert(clones, new)
            end
        end

        history.endAction()
        selection.setSelection(clones)
	end
})

keybinder:bind({
    name = "duplicate",
    key = enums.key.d,
    priorKey = enums.key.leftCtrl,
	action = function()
        history.beginAction(workspace, "Duplicate")
        local clones = {}
        for _,v in pairs(selection.selection) do
            if v and v.alive then
                local new = v:clone()
                new.parent = workspace
                table.insert(clones, new)
            end
		end
        history.endAction()
        selection.setSelection(clones)
	end
})