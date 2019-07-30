--[[
	create.lua
	Copyright (c) 2019 teverse.com

	This script is launched when the user loads create mode,
	it is given workshop level sandboxing permissions.

	However, scripts required from this script will not inherit workshop apis.
	We overcome this by manually passing a reference to the workshop object to the required "main.lua" script.

	------------------------------------------------
	-- SETTING UP A LOCAL DEVELOPMENT CREATE MODE --
	------------------------------------------------

	1) Make sure you're looking at your local version 
	   of this script and not the git version.

	   On Windows, this script can be found at "%localappdata%/teverse/create.lua"

	2) Clone the Teverse Repo from Github anywhere on your PC e.g. your Desktop, 
	   preferably away from the Teverse directory.

	   >> git clone https://github.com/teverse/teverse.git
	
	3) Uncomment LINE 42 below, 
	   making sure to include the FULL PATH to your newly cloned repo.

	   (!) You must include a following forward slash (!)

	   (!) Do not use backslashes (!)

	   VALID examples:
	   >> engine.workshop:setTevGit("C:/Users/YOURNAME/Desktop/teverse/")
	   >> engine.workshop:setTevGit("C:/teverse/")
	   >> engine.workshop:setTevGit("C:/Users/YOURNAME/Documents/teverse/")	  

	   (!) BAD examples:
	   (!) >> engine.workshop:setTevGit("C:/Users/YOURNAME/Desktop/teverse") -- missing slash on the end
	   (!) >> engine.workshop:setTevGit("C:\Users\YOURNAME\Desktop\teverse\") -- backslashes
]]

--engine.workshop:setTevGit('C:/Users/YOURNAME/Desktop/teverse/')

require("tevgit:create/main.lua")(engine.workshop)
