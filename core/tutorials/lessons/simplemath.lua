local framework = require("tevgit:core/tutorials/framework.lua")

return {
    name = "Simple Mathematics",
    description = "Simple mathematic operations",
    pages = {
        framework.titleDesc("Simple Math", "Using mathematics in your code"),
        framework.exampleCode("Arithmetic Operators",
[[Arithmetic operations are sometimes necessary to determine how to handle arguments or conditions.

Lua can handle the typical math operators:
"+" for addition, "-" for subtractions, "*" for multiplication, and "/" for division.

For our example, we are using the 'print()' function to produce math operations, which are printed in the console.
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
]])
    }
}
