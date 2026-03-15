--disable
local button = script.Parent
local RS = game.ReplicatedStorage.RemoteEvents.RoundEditEvents

button.MouseButton1Down:Connect(function()
	RS.Edit:InvokeServer("Spike")
end)