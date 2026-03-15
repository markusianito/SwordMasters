--disable
local RS = game.ReplicatedStorage.RemoteEvents.RoundEditEvents

for i,v in pairs(script.Parent:GetChildren())do
	if v:IsA("ImageButton") then
		v.MouseButton1Down:Connect(function()
			script.Parent.Visible = false
			RS.Edit:InvokeServer(v.Name)

		end)
	end
end