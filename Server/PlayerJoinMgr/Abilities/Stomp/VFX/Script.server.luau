local a = script.Parent:WaitForChild("LeftFootAttachment")
game["Run Service"].Heartbeat:Connect(function()
	a.WorldOrientation = Vector3.zero;
end)