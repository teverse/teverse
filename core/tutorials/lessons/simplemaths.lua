local framework = require("tevgit:core/tutorials/framework.lua")

return {
    name = "Simple Mathematics",
    description = "Simple mathematic operations",
    pages = {
        framework.exampleCode("Arithmetic Operators",
[[Arithmetic operations are sometimes necessary to determine how to handle arguments or conditions.

Lua can handle the typical maths operators:
"+" for addition, "-" for subtractions, "*" for multiplication, and "/" for division.

For our example, we are using the 'print()' function to display the results of these maths operations.
The console is what you see on the right of the screen.
        
When you're ready to continue, press next at the bottom of your screen.
        
Example Output from the script on the left:]],
[[--Addition
print(1+2)
--Subtraction
print(3-1)
--Multiplication
print(4*2)
--Division
print(2/1)
]],
[[
3
2
8
2
]]),
    framework.interactiveCode("Try it: Arithmetic Operations",
    [[Now that you know the basic operators, let's try to use them.
    For each of the following samples, make the output equal 20, using the operation in between the two quotation marks.
    You may need to include numbers as well. When you think you have it, press run.]],
    [[print(12 "addition" __ )

-- Friendly reminder: print(1 + 1) will display 2]],
    function(script, logs)
        local answer = "print(12+8)"
        local correct = script.text:lower():gsub(" ", ""):sub(0, answer:len()) == answer
        if not correct then
            print("Try again thats not quite right...\n")
        else
            print("Well done! Press next!\n")
        end
        return correct
    end),
    framework.interactiveCode("Try it: Arithmetic Operations",
    [[Now that you know the basic operators, let's try to use them.
    For each of the following samples, make the output equal 20, using the operation in between the two quotation marks.
    You may need to include numbers as well. When you think you have it, press run.]],
    [[print(2000 "division" __ )]],
    function(script, logs)
        local answer = "print(2000/100)"
        local correct = script.text:lower():gsub(" ", ""):sub(0, answer:len()) == answer
        if not correct then
            print("Try again thats not quite right...\n")
        else
            print("Well done! Press next!\n")
        end
        return correct
    end),
    framework.interactiveCode("Try it: Arithmetic Operations",
    [[Now that you know the basic operators, let's try to use them.
    For each of the following samples, make the output equal 20, using the operation in between the two quotation marks.
    You may need to include numbers as well. When you think you have it, press run.]],
    [[print(10 "multiplication" __ )]],
    function(script, logs)
        local answer = "print(10*2)"
        local correct = script.text:lower():gsub(" ", ""):sub(0, answer:len()) == answer
        if not correct then
            print("Try again thats not quite right...\n")
        else
            print("Well done! Press next!\n")
        end
        return correct
    end),
    framework.interactiveCode("Try it: Arithmetic Operations",
    [[Now that you know the basic operators, let's try to use them.
    For each of the following samples, make the output equal 20, using the operation in between the two quotation marks.
    You may need to include numbers as well. When you think you have it, press run.]],
    [[print(__ "subtraction" 40)]],
    function(script, logs)
        local answer = "print(60-40)"
        local correct = script.text:lower():gsub(" ", ""):sub(0, answer:len()) == answer
        if not correct then
            print("Try again thats not quite right...\n")
        else
            print("Well done! Press next!\n")
        end
        return correct
    end),
    }
}
