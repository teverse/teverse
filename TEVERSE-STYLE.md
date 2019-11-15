

## Naming
Teverse uses **camelCase** built-in for everything. As a result, we'll use camelCase in _every_ scenario except for constants. 
#### Bad
```lua
local foobar

local function FooBar(Baz)
-- ...

``` 
#### Good
```lua
local fooBar

local function bazQux(quz)
--..
```
### Variables
These should be able to be read by humans! Unless the function is very short, the name of the variable/argument should be verbose enough to describe its meaning. Please use locals and abstain from globals whenever possible.
#### Bad
```lua
function x(y, z)
-- ...
```
#### Good
```lua
local function runCourse(courseName, targetObjective)
    -- ...
```
## Documentation
To promote readability, understanding and maintainability of shared code, documentation is necessary for all methods.

#### Good
``` lua
local function foo(bar, baz)
    
    --[[
        @Description
            concatenates "foo" with {bar} and optionally {baz}

        @Params
            String, bar
                Description
            String, [baz]
                ...
        
        @Returns
            String, foobar
                ...
    ]]

    baz = baz or ""

    return "foo" .. bar .. baz 

end
```
## Lua Idioms
To test if a variable is not nil in a conditional, it is terser to write the variable name to explicitly compare against nil. Lua treats nil and false as false (and all other values as true) in a conditional. However, if the variable tested can contain false as well, then you'll need to be explicit if the two conditions must be differentiated: `line == nil` v.s. `line == false`.
#### Bad
```lua
if (foo ~= nil) then 
    -- ...
end

if (bar == nil) then
    -- ...
end
```
#### Good
```lua
if (foo) then 
    -- ...
end

if (not bar) then
    -- ...
end
```


`and` and `or` may be used for terser code:
#### Good
```lua
local foo = bar or "baz"
print(foo == "baz" and "qux" or "quz")
```

Clone a small table t (warning: this has a system dependent limit on table size; it was just over 2000 on one system):
#### Good
```lua
local foo = { 1, 2, 3 }
local baz = { unpack(foo) }
```

Determine if a table t is empty (including non-integer keys, which #t ignores):
#### Good
```lua
local foo = {}
if (next(t)) then 
-- ...
```

To append to an array, it can be terser and more efficient to insert numerically
#### Bad
```lua 
local foo = { 1, 2 }
table.insert(foo, 3)
```
#### Good
```lua
local foo = { 1, 2 }
foo[#foo + 1]  = 3
```

### Related Resources
http://lua-users.org/wiki/LuaStyleGuide



