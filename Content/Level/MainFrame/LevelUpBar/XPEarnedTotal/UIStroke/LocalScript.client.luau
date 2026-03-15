--disable
script.Parent.Parent:GetPropertyChangedSignal("TextStrokeTransparency"):Connect(function()
	script.Parent.Transparency = script.Parent.Parent.TextStrokeTransparency;
end)