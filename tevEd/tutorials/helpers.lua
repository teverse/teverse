return {
	runAndContinue = function (workshop, code)
		workshop:loadString(code)
	end
	code = function(code, action)
		return { type = "script", script = code, action = action }
	end
}