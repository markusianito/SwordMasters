--disable
local button = script.Parent
local frame = button.Parent.Parent:WaitForChild("PlayerStatsFrame")
button.Activated:Connect(function()
script.Parent.Parent.Visible = false
frame.Visible = true

end)



