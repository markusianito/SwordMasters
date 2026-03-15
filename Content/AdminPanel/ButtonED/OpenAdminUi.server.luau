local button = script.Parent
local frame = button.Parent:WaitForChild("MainFrame")
button.Activated:Connect(function()
	frame.Visible = not frame.Visible
end)
