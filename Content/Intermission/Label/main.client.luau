--disable
local remote = game.ReplicatedStorage.RemoteEvents.Round.Error


remote.OnClientEvent:Connect(function(massage)
	script.Parent.Text = massage
end)