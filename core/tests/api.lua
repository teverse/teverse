 -- Uses to test integrity of a sandbox

return function()
    print(_VERSION)
    print("Safety Test (TevC)", tevC == nil and "PASS" or "FAIL")
    print("Safety Test (jit)", jit == nil and "PASS" or "FAIL")
    print("Safety Test (ffi)", ffi == nil and "PASS" or "FAIL")
    print("Safety Test (events)", events == nil and "PASS" or "FAIL")
    print("Safety Test (os.open)", os.open == nil and "PASS" or "FAIL")
    print("Safety Test (os.write)", os.write == nil and "PASS" or "FAIL")
    print("Safety Test (teverse.userToken)", teverse.userToken == nil and "PASS" or "FAIL")
    print("Safety Test (globaltest)", globaltest == nil and "PASS" or "FAIL")

    print("Require Test #1", (require == nil) and "PASS" or "FAIL")
    print("Require Test #2", (teverse.load ~= nil and teverse.load("ping") == "pong") and "PASS" or "FAIL")

    local result = teverse.load("tevgit:core/tests/tevgit.lua")
    print("Require Test #3", result == "Hello World!" and "PASS" or "FAIL")

    local a = os.clock()
    print("Running Scheduler Test #1", a)
    sleep(1)
    local elapsed = os.clock() - a
    print("Scheduler Test #1", elapsed >= 1.0 and "PASS" or "FAIL", elapsed)
end