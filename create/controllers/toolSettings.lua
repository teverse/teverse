--the purpose of this script is to unify all the tools
--by allowing each one to access the same common settings
--set by the user

local controller = {}

controller.gridStep = 0.25
controller.axis = {{"x", true},{"y", false},{"z", true}} -- should grid step be on .. axis

return controller