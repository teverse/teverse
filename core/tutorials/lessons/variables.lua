local framework = require("tevgit:core/tutorials/framework.lua")

return {
    name = "Variables",
    description = "Learning Variables",
    pages = {
        framework.interactiveCode("Naming things in our world ",
            [[Variables are a way of storing data in your code. In Lua, a variable can contain any 'type' - for example: numbers, strings and tables.

Try pressing run right now and take note of what displays in the console.

Then type testVariable between the two quotation marks, and press run again]],
                [[local newVariable = "example"

print(newVariable)]],
                    function(script, logs)
                        local answer = "localnewvariable=\"testvariable\""
                        local correct = script.text:lower():gsub(" ", ""):sub(0, answer:len()) == answer
                        if not correct then
                            local answer = "localnewvariable=\"example\""
                            correct = script.text:lower():gsub(" ", ""):sub(0, answer:len()) == answer
                            if correct then
                                print("As you can see, print(newVariable) displays the contents of the variable - AKA: example\n\nChange the value from example to testVariable\n")
                            else
                                print("Try again!\n")
                            end
                            return false
                        else
                            print("Well done, isn't setting variables a blast? Press next!\n")
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
