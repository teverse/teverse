local framework = require("tevgit:core/tutorials/framework.lua")

return {
    name = "Hello World",
    description = "test test test",
    tutorial = {
        framework.titleDesc("Test ", "Description"),
        framework.titleDesc("Test2 ", "Description2")
    }
}