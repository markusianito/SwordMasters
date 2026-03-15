--disable
task.wait()
local Module = require(game.ReplicatedFirst.DataLoad)
local Swords = Module.Swords

local plrs = game:GetService("Players");

while task.wait(0.25) do
	local plr;
	pcall(function()
		plr = plrs:FindFirstChild(workspace.CurrentCamera.CameraSubject.Parent.Name)
	end)
	if plr then

		local PlrData = plr:WaitForChild("Data")

		local PlrEquippedSword = PlrData:WaitForChild("EquippedSword")

		if Swords[PlrEquippedSword.Value] then
			script.Parent.ImageButton.SwordText.Text=PlrEquippedSword.Value
			script.Parent.ImageButton.SwordImage.Image = "rbxassetid://"..Swords[PlrEquippedSword.Value].ID
		end
	end
end