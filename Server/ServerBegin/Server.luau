
local players = game:GetService("Players")
local module = {}

module.ErrorIndex = {
	[0x1] = "Services failed to start. Error code: 1",
	[0x2] = "Failed to start a round, fatal error in server. Exit code: 2"
}

function module.ShutDownServer(errorcode: number)
	players.PlayerAdded:Connect(function(plr)
		plr:Kick(module.ErrorIndex[errorcode]);
	end)
	for _,v in pairs(players:GetPlayers()) do
		v:Kick(module.ErrorIndex[errorcode])
	end
end

return module
