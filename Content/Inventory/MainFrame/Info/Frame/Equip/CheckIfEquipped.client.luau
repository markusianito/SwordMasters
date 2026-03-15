--disable
task.wait()
local plr = game.Players.LocalPlayer
local data = plr:WaitForChild("Data")
local EquippedSword = data:WaitForChild("EquippedSword")
local EquippedSkin = data:WaitForChild("EquippedSkin")
local EquippedAbs = data:WaitForChild("EquippedAbilities")

local SelectedItem = script.Parent.Parent:WaitForChild("SelectedItem") 
local TypeOfItem = script.Parent.Parent:WaitForChild("TypeOfItem")


while true do
	if SelectedItem.Value== EquippedSword.Value  and TypeOfItem.Value == "Sword" then
		script.Parent.Text="Equipped"
		
	elseif SelectedItem.Value== EquippedSkin.Value and TypeOfItem.Value == "Skin" then
		script.Parent.Text="Equipped"
		
	elseif EquippedAbs:FindFirstChild(SelectedItem.Value) and TypeOfItem.Value == "Ability" then
		script.Parent.Text="Equipped"


		
	elseif (SelectedItem.Value~= EquippedSword.Value) or (SelectedItem.Value~=EquippedSkin.Value) or (not EquippedAbs:FindFirstChild(SelectedItem.Value)) then
		script.Parent.Text="Equip" 
		
	elseif SelectedItem.Value== EquippedSkin.Value and TypeOfItem.Value ~= "Skin" then
		script.Parent.Text="Equip"
		
	elseif SelectedItem.Value== EquippedSword.Value and TypeOfItem.Value ~= "Sword" then
		script.Parent.Text="Equip"
		
	elseif EquippedAbs:FindFirstChild(SelectedItem.Value) and TypeOfItem.Value ~= "Ability" then
		script.Parent.Text="Equip"


	end
	task.wait(0.25)
end


