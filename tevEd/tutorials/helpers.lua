return {
	runAndContinue = function (workshop, code)
		workshop:loadString(code)
		return true -- continue
	end,
	code = function(code, action)
		return { type = "script", script = code, btnText = "Run", action = action }
	end,
	helpText = function(text)
		return { type = "helpText", text = text }
	end
}