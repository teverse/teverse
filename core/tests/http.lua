-- test that the http api is functional

return function()
    print("Running http tests!")
    print("tested")
    local code, body = teverse.http:get("https://teverse.com/")
    print ("Http Test #1 https", code == 200 and "PASS" or "FAIL")

    local code, body = teverse.http:get("http://teverse.com/")
    print ("Http Test #2 http", code == 301 and "PASS" or "FAIL")

    teverse.http:get("https://teverse.com/", function(code, body)
        print ("Http Test #3 https async", code == 200 and "PASS" or "FAIL")
    end)

    teverse.http:get("http://teverse.com/", function(code, body)
        print ("Http Test #4 http async", code == 301 and "PASS" or "FAIL")
    end)

    local code, body = teverse.http:get("https://teverse.com/", {
        ["header-name"] = "test"
    })
    print ("Http Test #5 https header", code == 200 and "PASS" or "FAIL")

    teverse.http:get("https://teverse.com/", {
        ["header-name"] = "test"
    }, function(code, body)
        print ("Http Test #6 https async header", code == 200 and "PASS" or "FAIL")
    end)
end