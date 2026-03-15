local Equip = {}

local Display=require(script.Parent.Display)
local plr=game:GetService("Players").LocalPlayer

--TODO inventory buttons connecttions

Equip.EquipAbility=function(abilityName:string,slotIndex:number)
	--defences
	if abilityName==nil then return end
	--if not shared.IsInRound then return end
	if slotIndex==nil or slotIndex>2 then slotIndex=1 end
	
	shared.EquippedAbilities[slotIndex]=abilityName
	Display.EquipAbility(abilityName)
end

return Equip
