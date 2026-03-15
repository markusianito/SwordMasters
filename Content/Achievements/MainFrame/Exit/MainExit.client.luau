local btn = script.Parent

local isHovering = false


btn.MouseEnter:Connect(function()

	isHovering = true

	btn:TweenSize(UDim2.new(0.104, 0,0.098, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseLeave:Connect(function()

	isHovering = false

	btn:TweenSize(UDim2.new(0.108, 0,0.102, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Down:Connect(function()

	btn:TweenSize(UDim2.new(0.100, 0,0.094, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Up:Connect(function()

	if not isHovering then
		btn:TweenSize(UDim2.new(0.108, 0,0.102, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	else
		btn:TweenSize(UDim2.new(0.104, 0,0.098, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	end
end)


local Sound = script.Parent.ClickX

script.Parent.MouseButton1Click:Connect(function()
	Sound:Play()
end)

script.Parent.MouseButton1Click:Connect(function() 
	script.Parent.Parent.Visible = false
end)

