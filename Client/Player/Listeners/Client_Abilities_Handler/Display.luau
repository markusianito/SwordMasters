local Display = {}

local plr=game:GetService("Players").LocalPlayer

local function getAbilitySlot()
	return plr:WaitForChild("PlayerGui"):WaitForChild("AbilitySlot")
end

local ReplicatedSettings=require(game:GetService("ReplicatedStorage"):WaitForChild("Client_Modules"):WaitForChild("ReplicatedSettings"))

local isHoldingActivationKey=false
local isInCooldown=false

local disturb = script.Parent.Disturb

Display.HoldActivationKey=function()
	isHoldingActivationKey=true
	local slot=getAbilitySlot()["Slot"..tostring(1)]
	slot.AbilityImage.ImageTransparency=0.7
end

Display.ReleaseActivationKey=function()
	isHoldingActivationKey=false
	local slot=getAbilitySlot()["Slot"..tostring(1)]
	if not isInCooldown then
		slot.AbilityImage.ImageTransparency=0
	end
end

local annoy = false;
game.ReplicatedStorage.ClientEvents.Annoy.OnClientEvent:Connect(function()
	annoy = true;
	disturb:Fire(true)
end)


local function handleCountdown(timeInSeconds:number,slotNumber)
	local slot=getAbilitySlot()["Slot"..tostring(slotNumber)]
	local k=0
	local isDed = false;
	slot.Countdown.Visible=true
	slot.Countdown.Text=tostring(timeInSeconds)
	slot.AbilityImage.ImageTransparency=0.7
	isInCooldown=true

	
	local countdown = coroutine.create(function()
		while task.wait(1) do
			k+=1
			slot.Countdown.Text=tostring(timeInSeconds-k)
			if k==timeInSeconds or (not (shared.IsInRound or shared.IsRoundRunning or isDed or annoy))then annoy = false break end
		end
	end)
	coroutine.resume(countdown);

	local hum:Humanoid, connection;
	pcall(function()
		hum = plr.Character.Humanoid
	end)
	if hum then
		connection = hum.Died:Connect(function()
			isDed = true;
			shared.running = false;
			shared.lood = true;
			Display.ReleaseActivationKey()
			coroutine.close(countdown);
			if connection then
				connection:Disconnect();
				connection = nil;
			end
		end)
	end

	while task.wait() do
		if (not (shared.IsInRound or shared.IsRoundRunning)) or (isDed) or (annoy) then
			k = timeInSeconds;
			Display.ReleaseActivationKey()
			coroutine.close(countdown);
			annoy = false;
			break;
		end
		if k == timeInSeconds then
			annoy = false;
			break
		end;
	end

	slot.Countdown.Visible=false
	isInCooldown=false
	if isHoldingActivationKey then return end
	slot.AbilityImage.ImageTransparency=0	
end

Display.UseAbility=function(abilityName:string)
	local SlotIndex=table.find(shared.EquippedAbilities,abilityName)
	if not SlotIndex then return end

	local slotButton=getAbilitySlot():WaitForChild("Slot"..tostring(SlotIndex))
	task.spawn(handleCountdown,ReplicatedSettings.Abilities[abilityName].Cooldown,SlotIndex)
end

Display.EquipAbility=function(abilityName:string)
	local slot=getAbilitySlot()["Slot".."1"]-- change when multiple slots

	slot.AbilityImage.Image= workspace:GetAttribute("robloxstr") .. ReplicatedSettings.Abilities[abilityName].ID
	slot.AbilityName.Text=abilityName
	--print("displayed ability equip slot")
end

local function getEquippedAbility()
	while #plr:WaitForChild("Inventory"):WaitForChild("EquippedAbilities"):GetChildren()==0 do
		task.wait()
	end
	for i,v in pairs(plr:WaitForChild("Inventory"):WaitForChild("EquippedAbilities"):GetChildren()) do
		--print("equipped ability: "..v.Name)
		return v.Name
	end
end

local connections={}

--warn("initialized")
local function onCharAdded()
	for i,v in pairs(connections) do
		v:Disconnect()
	end

	Display.EquipAbility(getEquippedAbility())

	table.insert(connections,plr:WaitForChild("Inventory"):WaitForChild("EquippedAbilities").ChildAdded:Connect(function()
		Display.EquipAbility(getEquippedAbility())
	end))
end

if plr.Character then onCharAdded() end
plr.CharacterAdded:Connect(onCharAdded)

return Display
