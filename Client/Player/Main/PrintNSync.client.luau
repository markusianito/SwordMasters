--disable
local doPrint = game.ReplicatedStorage.DoPrint;

doPrint.OnClientEvent:Connect(function(service, text, mode)
	local str = `{service} %s: {text}`
	
	if mode == "warn" then
		
		warn(str:format("Warning"));
	elseif mode == "print" then
		
		print(str:format("Message"));
	elseif mode == "error" then
		
		error(str:format("Error"));
	end;
end)