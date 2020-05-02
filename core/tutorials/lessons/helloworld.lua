local framework = require("tevgit:core/tutorials/framework.lua")

return {
    name = "Hello World",
    description = "test test test",
    pages = {
        framework.titleDescCode("Saying Hello to the World ", 
            [[Welcome to the very first lesson in Teverse.]],
            [[print("Hello World")]]),
        framework.titleDesc("Test2 ", "Description2")
    }
}