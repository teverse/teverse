print("Using new require method to load create mode from github.")

--This script has access to workshop apis, 
--However, scripts required from this script will not.
--Manually pass workshop to the module:
require("tevgit:create/main.lua")(engine.workshop)
