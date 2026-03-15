local Equip = {}

local EquipEvent=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Equip")

local function onEquip(plr,abilityName)
	plr.Inventory.EquippedAbilities:FindFirstChildOfClass("StringValue").Name = abilityName;
end

EquipEvent.OnServerEvent:Connect(onEquip)

return Equip
