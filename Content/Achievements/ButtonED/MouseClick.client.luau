local btn = script.Parent
local frm = script.Parent.Parent:WaitForChild("MainFrame")

local isHovering = false


btn.MouseEnter:Connect(function()

	isHovering = true

	btn:TweenSize(UDim2.new(0.04,0 ,0.07, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseLeave:Connect(function()

	isHovering = false

	btn:TweenSize(UDim2.new(0.044,0 ,0.074, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Down:Connect(function()

	btn:TweenSize(UDim2.new(0.034,0 ,0.064, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Up:Connect(function()

	if not isHovering then
		btn:TweenSize(UDim2.new(0.044,0 ,0.074, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	else
		btn:TweenSize(UDim2.new(0.04,0 ,0.07, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	end
end)

local Sound = script.Parent.ClickAchievements

script.Parent.MouseButton1Click:Connect(function()
	frm.Visible = not frm.Visible
	Sound:Play()
end)