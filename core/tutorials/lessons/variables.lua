local framework = require("tevgit:core/tutorials/framework.lua")

return {
    name = "Variables",
    description = "Learning Variables",
    pages = {
        framework.interactiveCode("Naming things in our world ",
            [[Let's jump straight into creating your first variables!
Try pressing run right now and take note of what displays in the console.

Then type testVariable between the two quotation marks, and press run again]],
                [[local newVariable = "blank"

print(newVariable)]],
                    function(script, logs)
                        local correct = script.text:lower() == "local newvariable = \"testvariable\""
                        if not correct then
                            print("Try again thats not quite right...\n")
                        else
                        local newVariable = "testVariable"
                            print("Well done, isn't setting variables a blast? Press next!\n")
                            print(newVariable)
                        end
                        return correct
                    end),
                    framework.exampleCode("Dissecting your script",
[[A variable is a way to assign a name to something.

Variables can come in the form of multiple types: strings, numbers, booleans, tables, functions, and much more!

In the first section, you declared the variable "newVariable" as a string "testVariable"; a string is usually a phrase or non-numeric set of characters.

The print function simply outputs the variables in the console. The console is what you see on the right of the screen.

When you're ready to continue, press next at the bottom of your screen.

Example Output from the script on the left:]],
[[local newPhrase = "This is a string"
local newNumber = 4

print(newPhrase)
print(newNumber)

]], [["This is a string"
4
]]),

    }
}
