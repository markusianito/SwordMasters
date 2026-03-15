--disable
local btn = script.Parent

local isHovering = false


btn.MouseEnter:Connect(function()

	isHovering = true

	btn:TweenSize(UDim2.new(0.125, 0,0.151, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseLeave:Connect(function()

	isHovering = false

	btn:TweenSize(UDim2.new(0.121, 0,0.147, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Down:Connect(function()

	btn:TweenSize(UDim2.new(0.117, 0,0.143, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Up:Connect(function()

	if not isHovering then
		btn:TweenSize(UDim2.new(0.121, 0,0.147, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	else
		btn:TweenSize(UDim2.new(0.125, 0,0.151, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	end
end)

local Sound = script.Parent.ClickAbilities

script.Parent.MouseButton1Click:Connect(function()
	Sound:Play()
end)