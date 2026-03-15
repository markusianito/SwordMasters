--disable
local equip = require(game.ReplicatedStorage.Client_Modules.Client_Abilities_Handler.Equip);



script.Parent.MouseButton1Click:Connect(function()
	if script.Parent.Parent.SelectedItem.Value~="" then
		if script.Parent.Parent.TypeOfItem.Value~="" then
			if  script.Parent.Parent.SelectedItem.Value==game.Players.LocalPlayer.Data.EquippedSkin.Value  and script.Parent.Parent.TypeOfItem.Value=="Skin" then

			elseif script.Parent.Parent.SelectedItem.Value==game.Players.LocalPlayer.Data.EquippedSword.Value and script.Parent.Parent.TypeOfItem.Value=="Sword" then
				
			else

				if script.Parent.Parent.TypeOfItem.Value == "Ability" then
					local app = game.ReplicatedStorage.RemoteEvents.DataEvents.ChangeEquipped:InvokeServer(script.Parent.Parent.SelectedItem.Value,script.Parent.Parent.TypeOfItem.Value );
					repeat task.wait() until app
					
					equip.EquipAbility(script.Parent.Parent.SelectedItem.Value, 1)
					warn("Equipped iguess")
				else
					game.ReplicatedStorage.RemoteEvents.DataEvents.ChangeEquipped:InvokeServer(script.Parent.Parent.SelectedItem.Value,script.Parent.Parent.TypeOfItem.Value );
				end
			end
		end
	end
end)