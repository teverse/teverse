local framework = require("tevgit:core/tutorials/framework.lua")

return {
    name = "Variables",
    description = "Learning Variables",
    pages = {
        framework.interactiveCode(
            "Naming things in our world ", 
            [[Let's jump straight into creating your first variables!
            
Type testVariable between the two quotation marks, then press run]],
            [[local newVariable = "blank"]],
            function(script, logs)
                local correct = script.text:lower() == "local newvariable = \"testvariable\""
                if not correct then
                    print("Try again thats not quite right...\n")
                else
                    local newVariable = "testVariable"
                    print("Well done! Press next!\n")
                    print(newVariable)
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
        )
    }
}