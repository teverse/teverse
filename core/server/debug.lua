engine.debug:output(function(msg, type)
	-- in the future this should not be sent to all clients!
	engine.networking:toAllClients("serverOutput", os.time(), msg, type)
end)