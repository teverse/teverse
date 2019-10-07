local tevEd = {}

tevEd.tutorials = {}

tevEd.addTutorial = function( section, name, module )
	if not tevEd.tutorials[section] then
		tevEd.tutorials[section] = {}
	end

	table.insert(tevEd.tutorials[section], {name, module})
end

return tevEd