local btn = script.Parent

local isHovering = false


btn.MouseEnter:Connect(function()

	isHovering = true

	btn:TweenSize(UDim2.new(0.082, 0,0.137, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseLeave:Connect(function()

	isHovering = false

	btn:TweenSize(UDim2.new(0.086, 0,0.141, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Down:Connect(function()

	btn:TweenSize(UDim2.new(0.078, 0,0.133, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Up:Connect(function()

	if not isHovering then
		btn:TweenSize(UDim2.new(0.086, 0,0.141, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	else
		btn:TweenSize(UDim2.new(0.082, 0,0.137, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	end
end)


local Sound = script.Parent.ClickX

script.Parent.MouseButton1Click:Connect(function()
	Sound:Play()
end)

script.Parent.MouseButton1Click:Connect(function() 
	script.Parent.Parent.Visible = false
end)

