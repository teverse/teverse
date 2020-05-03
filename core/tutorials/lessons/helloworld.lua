local framework = require("tevgit:core/tutorials/framework.lua")

return {
    name = "Hello World",
    description = "test test test",
    pages = {
        framework.interactiveCode(
            "Saying Hello to the World ", 
            [[Let's jump straight into writing your first script!
            
Type Hello World between the two quotation marks, then press run]],
            [[print("hello world")]],
            function(script, logs)
                local correct = script.text:lower() == "print(\"hello world\")"
                if not correct then
                    print("Try again thats not quite right...\n")
                else
                    print("Well done! Press next!\n")
                end
                return correct
            end
        ),
        framework.exampleCode(
            "Dissecting your script",
[[A function contains a set of commands that the system follows.

You ran the 'print' function and you passed the parameter "Hello World" to it.

The print function simply outputs the stuff you give it to the console. The console is what you seen on the right of the screen.

Example Output from the script on the left:]],
[[print("Hello World")

print("We can put anything here")
]],
[[Hello World
We can put anything here
]]
        ),
        framework.titleDesc("The end ", "Placeholder")
    }
}